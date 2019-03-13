#!/bin/bash
set -e

PATSOPT="$PATSHOME/bin/patsopt"

if (( $# != 1 ))
then
    for fname in fixtures/*.dats; do
        ./ats_go.sh "${fname}" # > /dev/null 2>&1
    done
else
    ./ats_go.sh "$@"
fi