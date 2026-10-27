abbr  lazydots 'lazygit -p $DOTFILES'
abbr  dots '$DOTFILES'
abbr  dstow 'stow -d $DOTFILES -t $HOME --dotfiles'

abbr  cu 'sudo -s -u'
abbr  e '$EDITOR'
abbr  se 'sudoedit'

abbr  g 'git'

abbr  gs 'git status'
abbr  ga 'git add'
abbr  gp 'git pull'
abbr  gP 'git push'

abbr gb 'git branch'
abbr gba 'git branch -a'
abbr gbd 'git branch -d'

abbr gc 'git commit -v'
abbr gcm 'git commit -m'

abbr gco 'git checkout'
abbr gcob 'git checkout -b'
abbr gcom 'git checkout (git_main_branch)'
abbr gcod 'git checkout (git_develop_branch)'
abbr gcof 'git checkout (git_feature_prepend)/'

abbr gd 'git diff'

abbr gl 'git log'
abbr gls 'git log --stat'
abbr glsp 'git log --stat -p'
abbr glg 'git log --graph'
abbr glgda 'git log --graph --decorate --all'
abbr glgm 'git log --graph --max-count=10'
abbr glo 'git log --oneline --decorate'
abbr glog 'git log --oneline --decorate --graph'
abbr gloga 'git log --oneline --decorate --graph --all'

abbr gr 'git remote -v'
abbr gra 'git remote add'
abbr grau 'git remote add upstream'
abbr grrm 'git remote remove'
abbr grmv 'git remote rename'
abbr grset 'git remote set-url'
abbr gru 'git remote update'
abbr grv 'git remote -v'
abbr grvv 'git remote -vvv'

abbr py-uv-dir 'echo "layout uv" > .envrc; direnv allow'
abbr py-dir 'echo "layout python3" > .envrc; direnv allow'
abbr py-venv 'source .venv/bin/activate.fish'

