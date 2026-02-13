abbr --add --global pythondir 'echo "layout python3" > .envrc; direnv allow'
abbr --add --global lazydots 'lazygit -p $DOTFILES'
abbr --add --global dots '$DOTFILES'
abbr --add --global dstow 'stow -d $DOTFILES -t $HOME --dotfiles'

