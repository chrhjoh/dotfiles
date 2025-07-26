#!/bin/bash

system_type=$(uname -s)
system_name=$(hostname -s)

if [[ "$system_type" == "Darwin" ]]; then

  # Install Homebrew if it's missing
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brewfile="bootstrap/homebrew/Brewfile.$system_name"
  if [[ -f "$brewfile" ]]; then
    echo "Updating Homebrew from $brewfile"
    brew bundle --file="$brewfile"
  else
    echo "No Brewfile found at $brewfile"
  fi

fi
