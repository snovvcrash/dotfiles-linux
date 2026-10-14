#!/usr/bin/env bash
#
# Rebuilds ONLY qtermwidget from apt source so that:
#
#   * When an app owns the mouse (tmux with `set -g mouse on`, vim, ...):
#       right-click  -> goes straight to the app (tmux paste), no menu
#       Shift+RClick -> opens the terminal menu (escape hatch)
#   * Otherwise (plain shell):
#       right-click  -> the normal qterminal menu, unchanged
#   * Tab bar: stock right-click menu (never conflicts with tmux).
#
# "tmux-detection" is done via the terminal's own mouse-tracking state
# (DECSET 1000..1003) -- i.e. "an application currently owns the mouse" --
# more reliable than process sniffing and it covers vim/htop too.
#
# qterminal itself stays the untouched distro package. The v2 hotkey
# (Ctrl+Shift+M) was removed: it could never work, because the terminal
# display claims key sequences via Qt's ShortcutOverride mechanism, which
# suppresses QShortcuts over the terminal area. Shift+right-click replaces it.
# If a v2-patched qterminal is installed, this script restores the stock one.
#
# Usage:
#   chmod +x patch-qterminal-menu-hotkey.sh
#   ./patch-qterminal-menu-hotkey.sh
#
# Everything happens in /tmp/qterminal-hotkey-build, wiped and re-created on
# every run -- safe to re-run from scratch any time. Needs sudo and deb-src
# (enabled automatically by this script).
#
# Undo everything:
#   sudo apt-mark unhold libqtermwidget6-2 qtermwidget-data libqtermwidget-dev
#   sudo apt-get install --allow-downgrades \
#     libqtermwidget6-2=2.4.0-1 qtermwidget-data=2.4.0-1 libqtermwidget-dev=2.4.0-1

set -euo pipefail

WORKDIR="/tmp/qterminal-hotkey-build"
EXPECTED_VERSION="2.4.0-1"
HOLD_PKGS="libqtermwidget6-2 qtermwidget-data libqtermwidget-dev"

step() { echo; echo "==> $*"; }
die()  { echo "ERROR: $*" >&2; exit 1; }

[ "$(id -u)" -ne 0 ] || die "run as your normal user; sudo is called where needed"
command -v apt-get >/dev/null 2>&1 || die "this script targets apt-based systems (Kali)"

step "Checking installed version (sanity)"
inst_v="$(dpkg-query -W -f'${Version}' qtermwidget 2>/dev/null || true)"
if [ -n "$inst_v" ] && [ "$inst_v" != "$EXPECTED_VERSION" ]; then
  echo "[warn] installed qtermwidget is $inst_v; patch anchors were verified"
  echo "       against $EXPECTED_VERSION. The patcher fails loudly if they moved."
fi

step "Enabling deb-src if missing"
enable_debsrc() {
  if [ -f /etc/apt/sources.list.d/kali.sources ]; then
    if grep -qE '^Types:.*\bdeb-src\b' /etc/apt/sources.list.d/kali.sources; then
      echo "deb-src already enabled (kali.sources)"
      return 0
    fi
    sudo cp -a /etc/apt/sources.list.d/kali.sources \
         "/etc/apt/sources.list.d/kali.sources.bak.$(date +%Y%m%d%H%M%S)"
    sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/kali.sources
    grep -qE '^Types:.*\bdeb-src\b' /etc/apt/sources.list.d/kali.sources \
      || die "could not edit Types: line in kali.sources -- add deb-src by hand"
    echo "deb-src enabled in /etc/apt/sources.list.d/kali.sources (backup saved)"
  elif grep -qE '^[[:space:]]*deb-src ' /etc/apt/sources.list 2>/dev/null; then
    echo "deb-src already enabled (sources.list)"
  elif grep -qE '^[[:space:]]*deb ' /etc/apt/sources.list 2>/dev/null; then
    sudo cp -a /etc/apt/sources.list "/etc/apt/sources.list.bak.$(date +%Y%m%d%H%M%S)"
    grep -E '^[[:space:]]*deb ' /etc/apt/sources.list | head -n1 \
      | sed 's/^[[:space:]]*deb /deb-src /' | sudo tee -a /etc/apt/sources.list >/dev/null
    echo "deb-src line appended to /etc/apt/sources.list (backup saved)"
  else
    die "no usable apt sources found -- enable deb-src manually and re-run"
  fi
}
enable_debsrc

step "apt update + build tools + build dependencies (needs sudo)"
sudo apt-get update
sudo apt-get install -y build-essential devscripts fakeroot
sudo apt-get build-dep -y qtermwidget

step "Fetching sources into $WORKDIR (wiped clean first)"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"
apt-get source qtermwidget
QW_DIR="$(find . -maxdepth 1 -type d -name 'qtermwidget-*' | head -n1)"
[ -n "$QW_DIR" ] || die "could not find extracted qtermwidget-* source directory"
echo "qtermwidget: $QW_DIR"

step "Applying patches"
python3 - "$QW_DIR" <<'PYEOF'
import os
import sys


def patch(path, replacements, marker):
    # newline="" keeps the file's own line endings instead of letting the
    # platform translate them (matters on Windows; no-op on Linux)
    with open(path, "r", encoding="utf-8", newline="") as f:
        src = f.read()
    if marker in src:
        print(f"[skip] {path}: already patched")
        return
    for old, new in replacements:
        n = src.count(old)
        if n != 1:
            sys.exit(f"[FATAL] expected exactly 1 occurrence in {path}, found {n}:\n"
                     f"{old[:200]}\n"
                     f"Package version probably differs from 2.4.0. Apply by hand.")
        src = src.replace(old, new, 1)
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(src)
    print(f"[ok] patched {path}")


qw_dir = sys.argv[1]

# Swallow the context-menu event while an application owns the mouse
# (tmux/vim/... with mouse tracking on) so the right-click reaches the
# application. Shift+right-click keeps the menu; without mouse tracking
# nothing changes.
qwh = os.path.join(qw_dir, "lib", "TerminalDisplay.h")
patch(qwh, [
    ("class QEvent;\nclass QGridLayout;\nclass QKeyEvent;",
     "class QEvent;\nclass QGridLayout;\nclass QContextMenuEvent;\nclass QKeyEvent;"),
    ("    void mouseMoveEvent( QMouseEvent* ) override;",
     "    void mouseMoveEvent( QMouseEvent* ) override;\n"
     "    void contextMenuEvent(QContextMenuEvent* event) override;"),
], marker="contextMenuEvent(QContextMenuEvent* event) override;")

qwc = os.path.join(qw_dir, "lib", "TerminalDisplay.cpp")
patch(qwc, [
    ("#include <QClipboard>",
     "#include <QClipboard>\n#include <QContextMenuEvent>"),
    ("void TerminalDisplay::mousePressEvent(QMouseEvent* ev)",
     "void TerminalDisplay::contextMenuEvent(QContextMenuEvent* event)\n"
     "{\n"
     "  // _mouseMarks == false means the foreground application owns the\n"
     "  // mouse (mouse tracking enabled, e.g. tmux with `set -g mouse on`):\n"
     "  // swallow the context-menu event so the right-click reaches the\n"
     "  // application untouched. In every other case propagate as usual,\n"
     "  // and Shift+right-click always opens the terminal menu.\n"
     "  if (!_mouseMarks && !(event->modifiers() & Qt::ShiftModifier))\n"
     "    event->accept();\n"
     "  else\n"
     "    event->ignore();\n"
     "}\n"
     "\n"
     "void TerminalDisplay::mousePressEvent(QMouseEvent* ev)"),
], marker="void TerminalDisplay::contextMenuEvent(QContextMenuEvent* event)")

print("All patches applied.")
PYEOF

step "Building qtermwidget (can take a few minutes)"
( cd "$QW_DIR"
  DEBEMAIL="local@localhost" DEBFULLNAME="Local qtermwidget patch" \
    dch --local nomenu "Let right-click pass through to mouse-capturing apps (tmux) instead of opening the context menu"
  dpkg-buildpackage -us -uc -b -j"$(nproc)"
)

step "Built packages:"
ls -1 ./*.deb

debs=(./libqtermwidget6-2_*.deb ./qtermwidget-data_*.deb ./libqtermwidget-dev_*.deb)
for f in "${debs[@]}"; do
  [ -e "$f" ] || die "expected built package $f not found -- see output above"
done

step "Installing patched packages (needs sudo)"
sudo apt-get install -y "${debs[@]}"

step "Holding packages so 'apt upgrade' won't overwrite this build"
sudo apt-mark hold $HOLD_PKGS

# If a v2 build (with the dead Ctrl+Shift+M hotkey) is installed, put the
# stock qterminal back.
step "Restoring stock qterminal if a locally patched one is installed"
qtv="$(dpkg-query -W -f'${Version}' qterminal 2>/dev/null || true)"
sudo apt-mark unhold qterminal qterminal-l10n >/dev/null 2>&1 || true
case "$qtv" in
  *nomenu*)
    sudo apt-get install -y --allow-downgrades \
      "qterminal=$EXPECTED_VERSION" "qterminal-l10n=$EXPECTED_VERSION"
    echo "stock qterminal $EXPECTED_VERSION restored"
    ;;
  *)
    echo "qterminal is ${qtv:-not installed} -- already stock, nothing to restore"
    ;;
esac

cat <<EOM

==> Done. Close ALL qterminal windows and start it again (the library is
    loaded at process start).

New behavior (qterminal itself is the untouched distro package):
  - tmux/vim/... with mouse on:
      right-click   -> goes to the app (tmux paste), no menu
      Shift+RClick  -> opens the terminal menu (escape hatch)
  - plain shell:
      right-click   -> normal menu, unchanged
  - tab bar:
      right-click   -> normal menu, unchanged

Test:
  tmux new -s t   # with  set -g mouse on  in ~/.tmux.conf
  copy something, right-click inside tmux -> pastes
  Shift+right-click inside tmux -> terminal menu opens

Undo:
  sudo apt-mark unhold $HOLD_PKGS
  sudo apt-get install --allow-downgrades \\
    libqtermwidget6-2=$EXPECTED_VERSION qtermwidget-data=$EXPECTED_VERSION \\
    libqtermwidget-dev=$EXPECTED_VERSION

When Kali ships a newer qtermwidget (e.g. 2.5.0), the held packages stay on
2.4.0 until you re-run this script (it will need new anchors if upstream
moved the patched lines -- it fails loudly, never silently).

tmux side: right-click paste must be bound there, e.g. in ~/.tmux.conf:
  set -g mouse on
  bind -n MouseDown3Pane paste-buffer
EOM
