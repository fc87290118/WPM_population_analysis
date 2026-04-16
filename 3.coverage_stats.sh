#!/bin/bash
#SBATCH --job-name=coverage_stats
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=04:00:00
#SBATCH --out=coverage_%A_%a.out
#SBATCH --array=1-100
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/samtools:1.9--h91753b0_8

SAMPLE_LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_coverage_stats"
OUT_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/coverage_per_sample.tsv"
GENOME_SIZE=139956545   # set to your ref size

# read sample + BAM for this array task
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Sample: $SAMPLE"
echo "BAM: $BAM"

# get mapped reads and average length
mapped_and_len=$(singularity run samtools:1.9--h91753b0_8 samtools stats "$BAM" \
  | awk '
      /^SN[[:space:]]+reads mapped:/   {m=$4}
      /^SN[[:space:]]+average length:/ {l=$4}
      END { if (m>0 && l>0) print m, l; else print 0, 0 }
    ')

mapped_reads=$(echo "$mapped_and_len" | awk '{print $1}')
avg_len=$(echo "$mapped_and_len" | awk '{print $2}')

coverage=$(awk -v n="$mapped_reads" -v L="$avg_len" -v G="$GENOME_SIZE" \
  'BEGIN{ if (G>0) printf "%.3f", (n*L)/G; else print "NA" }')

# one line per sample:
# SAMPLE  mapped_reads  genome_size  coverage
printf "%s\t%s\t%s\t%s\n" "$SAMPLE" "$mapped_reads" "$GENOME_SIZE" "$coverage" >> "$OUT_TSV"

echo "[$(date)] Done: $SAMPLE  mapped=$mapped_reads  cov=${coverage}x"

