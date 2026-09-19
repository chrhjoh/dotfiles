if type -q brew; and test -d (brew --prefix)/opt/rustup/bin
    fish_add_path (brew --prefix)/opt/rustup/bin
end
