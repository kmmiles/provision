#!/bin/bash

DOWNLOADS="$HOME/Downloads"
export DOWNLOADS

################################################################################
# Downloads url
# Arguments:
#   The URL
# Outputs:
#   Absolute path of downloaded file on success
# Returns:
#   1 on error
################################################################################
dl() {
  local url filepath filename

  url="$1"
  if [[ -z "$url" ]]; then
    return 1
  fi

  filename=$(basename "$url")
  filepath="$DOWNLOADS/$filename"

  # destination directory must exist
  if [[ ! -d "$DOWNLOADS" ]]; then
    log_err "Directory does not exist \"$DOWNLOADS\"."
    return 1 
  fi

  # download file
  if [[ ! -f "$filepath" ]]; then
    log_info "Downloading \"$url\" to \"$DOWNLOADS\"..."
    if ! curl -sfL -o "$filepath" "$url" > /dev/null; then
      log_err "Failed to download \"$url\"."
      return 1
    fi
  fi

  # print path of downloaded file
  echo "$filepath"
}

