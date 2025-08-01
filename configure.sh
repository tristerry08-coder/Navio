#!/usr/bin/env bash
#
# Please run this script to configure the repository after cloning it.
#

SKIP_MAP_DOWNLOAD=false
SKIP_GENERATE_SYMBOLS=false

############################# PROCESS OPTIONS ################################

TEMP=$(getopt -o ms --long skip-map-download,skip-generate-symbols \
              -n 'configure' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
  case "$1" in
    -m | --skip-map-download ) SKIP_MAP_DOWNLOAD=true; shift ;;
    -s | --skip-generate-symbols ) SKIP_GENERATE_SYMBOLS=true; shift ;;
    * ) break ;;
  esac
done

# Shift the processed options away
shift $((OPTIND-1))

set -euo pipefail

###############################################################################

pushd() { command pushd "$@" > /dev/null; }
popd() { command popd "$@" > /dev/null; }

Diff() {
  local HASH_PATH=$1
  shift
  local HASH="$(md5sum "$@" | md5sum)"
  if [ "$HASH" != "$(cat "$HASH_PATH" 2>/dev/null)" ]; then
    printf "$HASH" > "$HASH_PATH"
  else
    false
  fi
}

if [ ! -d 3party/boost/tools ]; then
  git submodule update --init --recursive --depth 1
fi
if [ ! -d 3party/boost/boost ]; then
  pushd 3party/boost/
  ./bootstrap.sh
  ./b2 headers
  popd
fi

if [ "$SKIP_MAP_DOWNLOAD" = false ]; then
  pushd data
  
  MWM_VERSION=$(awk -F'[:,]' '/"v":/{ $2 = substr($2, 2); print $2 }' countries.txt)
  MWM_PATH="world_mwm/$MWM_VERSION"
  WORLD_PATH="$MWM_PATH/World.mwm"
  WORLD_PATH2="$MWM_PATH/WorldCoasts.mwm"

  mkdir -p "$MWM_PATH"

  if [ ! -f "$WORLD_PATH" ]; then
    echo "Downloading world map..."
    wget -N "https://cdn.comaps.app/maps/$MWM_VERSION/World.mwm" -P "$MWM_PATH" &&
    rm -f World.mwm; ln -s "$WORLD_PATH" World.mwm
  fi
  if [ ! -f "$WORLD_PATH2" ]; then
    wget -N "https://cdn.comaps.app/maps/$MWM_VERSION/WorldCoasts.mwm" -P "$MWM_PATH" &&
    rm -f WorldCoasts.mwm; ln -s "$WORLD_PATH2" WorldCoasts.mwm
  fi
  
  popd
else
  echo "Skipping world map download..."
fi

if [ "$SKIP_GENERATE_SYMBOLS" = false ]; then
  if Diff data/symbols_hash data/styles/*/*/symbols/*; then
    echo "Generating symbols..."
    bash ./tools/unix/generate_symbols.sh
  fi
else
  echo "Skipping generate symbols..."
fi
