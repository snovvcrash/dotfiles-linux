# Resolve DOTFILES_DIR

if [ -d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return
fi

# Source dotfiles

for DOTFILE in "$DOTFILES_DIR"/system/.{export,virtualenv}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done
