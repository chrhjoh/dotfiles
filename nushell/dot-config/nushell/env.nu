let starship_cache = "/Users/hcq343/.cache/starship"
if not ($starship_cache | path exists) {
  mkdir $starship_cache
}

load-env {}
