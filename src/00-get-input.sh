#!/usr/bin/env bash

set -euo pipefail

mkdir -p data/00-raw

./src/log "Retrieving files..."
tail +2 sources.txt | cut -d, -f3 \
    | xargs wget --continue --directory-prefix=data/00-raw
