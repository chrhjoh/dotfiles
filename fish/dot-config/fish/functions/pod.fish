function pod --wraps=podman
    sudo -u podman fish -c 'cd $HOME; podman $argv' -- $argv
end
