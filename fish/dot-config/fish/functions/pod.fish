function pod --wraps=podman
    sudo -u podman fish -c 'podman $argv' -- $argv
end
