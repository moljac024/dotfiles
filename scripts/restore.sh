#!/bin/bash
#------------------------------
# Backup restore script
#------------------------------
# Configuration
#------------------------------
restore_to_default="$HOME"
#------------------------------

set -o nounset

restore_from=$1
restore_to=${2:-$restore_to_default}

if [[ $EUID = 0 ]]; then
    echo "Ooops, you're running this as root! You better not!"
    exit 1
fi

if [[ ! -d $restore_to ]]; then
    mkdir -p $restore_to
fi

cd $restore_from
for f in *.tar.gz; do
    tar -xzvf "$f" --directory $restore_to
done

exit 0
