#!/usr/bin/env bash
# patch-qterminal-menu-hotkey.sh
#
# Rebuilds qterminal from apt source so BOTH right-click context menus
# (terminal area + tab bar) are triggered by a hotkey instead of right-click.
#
#   Terminal-area menu -> Ctrl+Shift+/
#   Tab-bar menu        -> Ctrl+Alt+M
#
# Usage:
#   chmod +x patch-qterminal-menu-hotkey.sh
#   ./patch-qterminal-menu-hotkey.sh
#
# All work happens in /tmp/qterminal-hotkey-build, which is wiped and
# re-created at the start of every run -- so this is safe to re-run
# from scratch any time (old source/build artifacts never linger,
# and nothing here is left behind for the OS to clean up later).
# Requires deb-src lines enabled in your apt sources.

set -euo pipefail

WORKDIR="/tmp/qterminal-hotkey-build"

echo "==> Cleaning up any previous run (starting fresh)"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "==> Working in $WORKDIR"

# echo "==> Installing build dependencies (needs sudo)"
# sudo apt-get update
# sudo apt build-dep -y qterminal
# sudo apt-get install -y devscripts python3

echo "==> Fetching qterminal source (needs deb-src enabled in sources.list)"
apt-get source qterminal

SRC_DIR=$(find . -maxdepth 1 -type d -name "qterminal-*" | head -n1)
if [ -z "$SRC_DIR" ]; then
  echo "ERROR: could not find extracted qterminal-* source directory."
  echo "Make sure deb-src lines are uncommented in /etc/apt/sources.list, then:"
  echo "  sudo apt-get update"
  exit 1
fi
echo "==> Found source at $SRC_DIR"

TERMWIDGET_CPP="$SRC_DIR/src/termwidget.cpp"
TABWIDGET_CPP="$SRC_DIR/src/tabwidget.cpp"
TABWIDGET_H="$SRC_DIR/src/tabwidget.h"

python3 - "$TERMWIDGET_CPP" "$TABWIDGET_CPP" "$TABWIDGET_H" <<'PYEOF'
import sys, re

termwidget_cpp, tabwidget_cpp, tabwidget_h = sys.argv[1:4]

# ---------------------------------------------------------------
# 1) termwidget.cpp: replace right-click policy/connect with a hotkey
# ---------------------------------------------------------------
with open(termwidget_cpp, "r", encoding="utf-8") as f:
    src = f.read()

if "QShortcut" not in src.split("customContextMenuCall")[0]:
    # add includes near the top, right after the first #include block
    src = src.replace(
        '#include <QMenu>',
        '#include <QMenu>\n#include <QShortcut>\n#include <QCursor>',
        1
    )

old_block = """    setContextMenuPolicy(Qt::CustomContextMenu);

    if(Properties::Instance()->swapMouseButtons2and3)
    {
        connect(this, &QWidget::customContextMenuRequested,
                this, &TermWidgetImpl::pasteSelection);
    }
    else
    {
        connect(this, &QWidget::customContextMenuRequested,
                this, &TermWidgetImpl::customContextMenuCall);
    }"""

new_block = """    setContextMenuPolicy(Qt::NoContextMenu);

    if(Properties::Instance()->swapMouseButtons2and3)
    {
        // right-click paste-on-click behavior left disabled here;
        // re-add in mousePressEvent if you rely on it
    }

    QShortcut *menuShortcut = new QShortcut(QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_Slash), this);
    connect(menuShortcut, &QShortcut::activated, this, [this]() {
        customContextMenuCall(mapFromGlobal(QCursor::pos()));
    });"""

if old_block in src:
    src = src.replace(old_block, new_block, 1)
    print(f"[ok] patched {termwidget_cpp}")
else:
    print(f"[FATAL] expected block not found verbatim in {termwidget_cpp} "
          f"(package version may differ). Aborting before build -- "
          f"edit that file by hand, see script comments for the intended change.")
    sys.exit(1)

with open(termwidget_cpp, "w", encoding="utf-8") as f:
    f.write(src)

# ---------------------------------------------------------------
# 2) tabwidget.cpp: split out showSessionMenu(), add shortcut
# ---------------------------------------------------------------
with open(tabwidget_cpp, "r", encoding="utf-8") as f:
    src = f.read()

if "QShortcut" not in src:
    src = src.replace(
        "#include <QMenu>",
        "#include <QMenu>\n#include <QShortcut>",
        1
    )

old_fn = """void TabWidget::contextMenuEvent(QContextMenuEvent *event)
{
    int tabIndex = tabBar()->tabAt(tabBar()->mapFrom(this, event->pos()));
    if (tabIndex == -1) {
        tabIndex = currentIndex();
    }
    if (tabIndex == -1) {
        return;
    }

    QMenu menu(this);
    QMap< QString, QAction * > actions = findParent<MainWindow>(this)->leaseActions();

    QAction *close = menu.addAction(QIcon::fromTheme(QStringLiteral("document-close")), tr("Close session"));
    QAction *rename = menu.addAction(actions[QLatin1String(RENAME_SESSION)]->text());
    QAction *changeColor = menu.addAction(QIcon::fromTheme(QStringLiteral("color-management")), tr("Change title color"));
    rename->setShortcut(actions[QLatin1String(RENAME_SESSION)]->shortcut());
    rename->blockSignals(true);

    QAction *action = menu.exec(event->globalPos());
    if (action == close) {
        emit tabCloseRequested(tabIndex);
    } else if (action == rename) {
        emit tabRenameRequested(tabIndex);
    } else if (action == changeColor) {
        emit tabTitleColorChangeRequested(tabIndex);
    }
}"""

new_fn = """void TabWidget::showSessionMenu(const QPoint &globalPos, int tabIndex)
{
    if (tabIndex == -1) {
        return;
    }

    QMenu menu(this);
    QMap< QString, QAction * > actions = findParent<MainWindow>(this)->leaseActions();

    QAction *close = menu.addAction(QIcon::fromTheme(QStringLiteral("document-close")), tr("Close session"));
    QAction *rename = menu.addAction(actions[QLatin1String(RENAME_SESSION)]->text());
    QAction *changeColor = menu.addAction(QIcon::fromTheme(QStringLiteral("color-management")), tr("Change title color"));
    rename->setShortcut(actions[QLatin1String(RENAME_SESSION)]->shortcut());
    rename->blockSignals(true);

    QAction *action = menu.exec(globalPos);
    if (action == close) {
        emit tabCloseRequested(tabIndex);
    } else if (action == rename) {
        emit tabRenameRequested(tabIndex);
    } else if (action == changeColor) {
        emit tabTitleColorChangeRequested(tabIndex);
    }
}

void TabWidget::contextMenuEvent(QContextMenuEvent *event)
{
    if (event->reason() == QContextMenuEvent::Mouse) {
        // right-click: intentionally ignored, use Ctrl+Alt+M instead
        return;
    }
    int tabIndex = tabBar()->tabAt(tabBar()->mapFrom(this, event->pos()));
    if (tabIndex == -1) {
        tabIndex = currentIndex();
    }
    showSessionMenu(event->globalPos(), tabIndex);
}"""

if old_fn in src:
    src = src.replace(old_fn, new_fn, 1)
    print(f"[ok] patched {tabwidget_cpp} (split contextMenuEvent)")
else:
    print(f"[FATAL] expected block not found verbatim in {tabwidget_cpp} "
          f"(package version may differ). Aborting before build -- "
          f"edit that file by hand, see script comments for the intended change.")
    sys.exit(1)

# add shortcut wiring inside the constructor: look for "TabWidget::TabWidget("
ctor_marker = re.search(r"TabWidget::TabWidget\([^\)]*\)\s*(?::[^\{]*)?\{", src)
if ctor_marker and "tabMenuShortcut" not in src:
    insert_pos = ctor_marker.end()
    shortcut_code = """
    QShortcut *tabMenuShortcut = new QShortcut(QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_M), this);
    connect(tabMenuShortcut, &QShortcut::activated, this, [this]() {
        showSessionMenu(mapToGlobal(tabBar()->tabRect(currentIndex()).center()), currentIndex());
    });
"""
    src = src[:insert_pos] + shortcut_code + src[insert_pos:]
    print(f"[ok] added tab-menu shortcut into TabWidget constructor")
else:
    print("[warn] could not locate TabWidget constructor to insert shortcut -- add manually")

with open(tabwidget_cpp, "w", encoding="utf-8") as f:
    f.write(src)

# ---------------------------------------------------------------
# 3) tabwidget.h: add the new method declaration
# ---------------------------------------------------------------
with open(tabwidget_h, "r", encoding="utf-8") as f:
    hsrc = f.read()

if "showSessionMenu" not in hsrc:
    # tolerant of extra whitespace / "override" / const, across qterminal versions
    m = re.search(r'[ \t]*void\s+contextMenuEvent\s*\(\s*QContextMenuEvent\s*\*\s*\w*\s*\)[^\n;]*;', hsrc)
    if m:
        indent_match = re.match(r'[ \t]*', m.group(0))
        indent = indent_match.group(0) if indent_match else "    "
        insertion = f"{indent}void showSessionMenu(const QPoint &globalPos, int tabIndex);\n"
        hsrc = hsrc[:m.start()] + insertion + hsrc[m.start():]
        print(f"[ok] added showSessionMenu declaration to {tabwidget_h}")
    else:
        print(f"[FATAL] could not find contextMenuEvent declaration in {tabwidget_h}.")
        print("        Add this line manually inside 'class TabWidget', under 'protected:':")
        print("        void showSessionMenu(const QPoint &globalPos, int tabIndex);")
        sys.exit(1)

with open(tabwidget_h, "w", encoding="utf-8") as f:
    f.write(hsrc)

print("Patching pass complete.")
PYEOF

echo "==> Bumping changelog so apt won't silently revert this build"
cd "$SRC_DIR"
DEBEMAIL="local@localhost" DEBFULLNAME="Local Hotkey Patch" dch -i "Rebind context menus to hotkeys instead of right-click (local patch)"

echo "==> Building .deb packages (this can take a few minutes)"
dpkg-buildpackage -us -uc -b

cd ..
echo "==> Build artifacts:"
ls -1 ./*.deb

echo "==> Installing patched packages (needs sudo)"
sudo dpkg -i ./qterminal_*.deb ./qterminal-*.deb 2>/dev/null || sudo apt-get install -f -y

echo "==> Holding qterminal so future 'apt upgrade' won't overwrite this build"
sudo apt-mark hold qterminal qterminal-common 2>/dev/null || true

cat <<'EOM'

==> Done.

New behavior:
  - Right-click in the terminal area: no menu. Press Ctrl+Shift+/
    to open it instead.
  - Right-click on a tab: no menu. Press Ctrl+Alt+M to open it
    for the current tab.

If a [warn] appeared above for either file, the exact source text
didn't match what this script expects (likely a different qterminal
version) -- open the file under /tmp/qterminal-hotkey-build/qterminal-*/src/
and apply the equivalent change by hand, then run
"dpkg-buildpackage -us -uc -b" from inside that source folder yourself.
(Just re-running this script from scratch will wipe your manual edit.)

To undo later:
  sudo apt-mark unhold qterminal qterminal-common
  sudo apt-get install --reinstall qterminal
EOM

sudo apt install --reinstall kali-themes
