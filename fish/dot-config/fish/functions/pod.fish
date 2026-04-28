function pod --wraps=podman
    sudo -u podman bash -c 'cd $HOME; podman "$@"' -- $argv
end
