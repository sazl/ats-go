#!/bin/bash

set -e

PATSOPT="$PATSHOME/bin/patsopt"

${PATSOPT} -d "$@" | ../build/ats-go -i