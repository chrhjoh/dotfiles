$env.config.show_banner = false

# Completion
$env.config.completions = {
    case_sensitive: false # case-sensitive completions
    quick: true    # set to false to prevent auto-selecting completions
    partial: true    # set to false to prevent partial filling of the prompt
    algorithm: "prefix"    # prefix or fuzzy
    external: {
    # set to false to prevent nushell looking into $env.PATH to find more suggestions
        enable: true 
    # set to lower can improve completion performance at the cost of omitting some options
        max_results: 100 
    }
}

# Direnv
$env.config.hooks.pre_prompt = [(source ./hooks/direnv.nu)]

# Catppuccin
source ./color_scheme.nu

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
