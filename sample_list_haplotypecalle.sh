#!/bin/bash
set -euo pipefail

COV_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/3b.bam_coverage_ge20x/coverage_ge20x.tsv"
BAM_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/2b.MarkDuplicates"
OUT_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_haplotypecaller"

: > "$OUT_TSV"

while read -r SAMPLE _; do
  BAM="${BAM_DIR}/${SAMPLE}.markdup.bam"
  if [[ -f "$BAM" ]]; then
    printf "%s\t%s\n" "$SAMPLE" "$(realpath "$BAM")" >> "$OUT_TSV"
  else
    echo "WARNING: BAM not found for $SAMPLE: $BAM" >&2
  fi
done < "$COV_TSV"
