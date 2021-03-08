#!/bin/bash

################################################################################
# Create a symlink
# Arguments:
#   src
#   dest
# Returns:
#   1 on bad input
################################################################################
symlink() {
  local src
  local dest

  src="${1:-}"
  dest="${2:-}"

  # quick sanity check of inputs
  if [[ -z "$src" || -z "$dest" ]]; then
    return 1
  fi

  # convert paths to absolute
  src="$(abspath "$src")"
  dest="$(abspath "$dest")"

  # don't overwrite existing files that aren't links
  if [[ -f "$dest" && ! -h "$dest" ]]; then
    backup="$(dirname "$dest")/$(basename "$dest").$(date '+%s')"
    log_warn "Cowardly refusing to overwrite, moving \"$dest\" -> \"$backup\""
    mv -f "$dest" "$backup"
  else
    rm -f "$dest"
  fi

  log_info "Linking \"$src\" -> \"$dest\""
  ln -sf "$src" "$dest"
}
