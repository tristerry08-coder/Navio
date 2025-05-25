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

echo "Configuring the repository for development."

if [ ! -d 3party/boost/tools ]; then
  git submodule update --init --recursive --depth 1
fi
pushd 3party/boost/
./bootstrap.sh
./b2 headers
popd

if [ "$SKIP_MAP_DOWNLOAD" = false ]; then
  echo "Downloading world map..."
  wget -N https://cdn.comaps.app/maps/latest/World.mwm -P ./data/
  wget -N https://cdn.comaps.app/maps/latest/WorldCoasts.mwm -P ./data/
else
  echo "Skipping world map download..."
fi

if [ "$SKIP_GENERATE_SYMBOLS" = false ]; then
  echo "Generating symbols..."
  bash ./tools/unix/generate_symbols.sh
else
  echo "Skipping generate symbols..."
fi

echo "The repository is configured for development."
