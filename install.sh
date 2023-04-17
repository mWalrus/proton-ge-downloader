#! /usr/bin/env bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
MAGENTA="$(tput setaf 5)"
RESET="$(tput sgr0)"

function log {
  printf "%s-> %s%s..." "$MAGENTA" "$RESET" "$1"
}

function run {
  if ! ERROR="$("$@" 2>&1)"; then
    printf "%s[failed]%s\n" "$RED" "$RESET"
    printf "ERROR: %s\n" "$ERROR"
    exit
  else
    printf "%s[ok]%s\n" "$GREEN" "$RESET"
  fi
}

# make temp working directory
log "Creating tmp dir"
mkdir /tmp/proton-ge-custom &> /dev/null
run cd /tmp/proton-ge-custom || return 1

log "Downloading tarball"
run curl -sLOJ "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .tar.gz)"

log "Downloading checksum"
run curl -sLOJ "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .sha512sum)"

log "Verifying checksum"
run sha512sum -c *.sha512sum

mkdir -p ~/.steam/root/compatibilitytools.d

log "Extracting tarball"
run tar -xf GE-Proton*.tar.gz -C ~/.steam/root/compatibilitytools.d/
echo "All done :)"
