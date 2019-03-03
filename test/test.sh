#!/bin/bash
set -e

PATSOPT="$PATSHOME/bin/patsopt"

for fname in fixtures/*.dats; do
    ${PATSOPT} -d "${fname}" | ../build/ats-go -i
done
