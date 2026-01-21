#!/bin/bash
set -euo pipefail

SRC="/scratch/y95/gracefang/"
DEST="/scratch/pawsey1142/gracefang/"

rsync -avh --progress \
  --partial \
  --inplace \
  "${SRC}" "${DEST}"
