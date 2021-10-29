#!/bin/bash

export LENSDIR=/home/lens/lens-linux
export PATH=${PATH}:${LENSDIR}/Bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${LENSDIR}/Bin

exec ${LENSDIR}/Bin/alens -batch $1
