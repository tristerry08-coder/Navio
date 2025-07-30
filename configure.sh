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

Diff() {
  local VER_PATH=$1
  shift
  local GIT_DIFF="$(git diff "$@")"
  local LAST_COMMIT=$(git log -n 1 --pretty=format:%H -- "$@")
  if [ "$LAST_COMMIT" != "$(cat "$VER_PATH" 2>/dev/null)" ]; then
    printf "$LAST_COMMIT" > "$VER_PATH"
  else
    false
  fi
  if [ "$GIT_DIFF" != "$(cat "$VER_PATH"1_ver 2>/dev/null)" ]; then
    printf "$GIT_DIFF" > "$VER_PATH"1_ver
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
  MWM_VERSION=$(awk -F'[:,]' '/"v":/{ $2 = substr($2, 2); print $2 }' data/countries.txt)
  MWM_PATH="data/world_mwm/$MWM_VERSION"
  WORLD_PATH="$MWM_PATH/World.mwm"
  WORLD_PATH2="$MWM_PATH/WorldCoasts.mwm"

  mkdir -p "$MWM_PATH"

  if [ ! -f "$WORLD_PATH" ]; then
    echo "Downloading world map..."
    wget -N "https://cdn.comaps.app/maps/$MWM_VERSION/World.mwm" -P "$MWM_PATH" &&
    rm data/World.mwm 2>/dev/null; ln -s "$WORLD_PATH" data/World.mwm
  fi
  if [ ! -f "$WORLD_PATH2" ]; then
    wget -N "https://cdn.comaps.app/maps/$MWM_VERSION/WorldCoasts.mwm" -P "$MWM_PATH" &&
    rm data/WorldCoasts.mwm 2>/dev/null; ln -s "$WORLD_PATH2" data/WorldCoasts.mwm
  fi
else
  echo "Skipping world map download..."
fi

if [ "$SKIP_GENERATE_SYMBOLS" = false ]; then
  if Diff data/_sym_ver data/styles/*/*/symbols; then
    echo "Generating symbols..."
    bash ./tools/unix/generate_symbols.sh
  fi
else
  echo "Skipping generate symbols..."
fi
