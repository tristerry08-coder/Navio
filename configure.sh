#!/usr/bin/env bash
#
# Please run this script to configure the repository after cloning it.
#

set -euo pipefail

echo "Configuring the repository for development."

if [ ! -d 3party/boost/tools ]; then
  git submodule update --init --recursive --depth 1
fi
pushd 3party/boost/
./bootstrap.sh
./b2 headers
popd
curl -C - -L --parallel --parallel-immediate --parallel-max 2 https://cdn.comaps.app/maps/latest/World.mwm -o data/World.mwm https://cdn.comaps.app/maps/latest/WorldCoasts.mwm  -o data/WorldCoasts.mwm
bash ./tools/unix/generate_symbols.sh
echo "The repository is configured for development."
