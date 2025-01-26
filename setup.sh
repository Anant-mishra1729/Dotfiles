#!/bin/bash

# Step 1: Install Kitty Terminal
echo "Installing Kitty Terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# Step 6: Install Zsh using dnf
echo "Installing Zsh..."
sudo dnf install -y zsh

# Step 7: Set Zsh as the default shell
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

# Step 8: Install Starship prompt
echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh

# Step 9: Set up Zsh history options in .zshrc
echo "Setting up Zsh history options..."
cat <<EOF >> ~/.zshrc

# Zsh history settings
HISTFILE=~/.zsh_history          # File where history is saved
HISTSIZE=10000                   # Number of history entries to keep in memory
SAVEHIST=10000                   # Number of history entries to save to HISTFILE
HISTCONTROL=ignoredups           # Ignore duplicate entries in history
HISTIGNORE="&:ls:ll:exit"        # Ignore common commands in history
setopt HIST_FIND_NO_DUPS         # Do not show duplicates when searching history
setopt HIST_IGNORE_ALL_DUPS      # Ignore all duplicate commands in history
setopt HIST_REDUCE_BLANKS        # Ignore leading blanks when saving to history
setopt HIST_EXPIRE_DUPS_FIRST    # Remove duplicate entries first when history file is full

EOF

# Step 10: Add Starship initialization to .zshrc
echo "Adding Starship to .zshrc..."
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Installing zsh plugins
echo "Sourcing zsh-autosuggestions in .zshrc..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc

echo "Sourciing zsh-syntaxhightlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  ~/.zsh/zsh-syntax-highlighting
echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

echo "Installing papirus icon theme"
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh

echo "Installation complete. Please restart your terminal for changes to take effect."

