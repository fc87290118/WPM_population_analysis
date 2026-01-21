#!/bin/bash
#SBATCH --job-name=samtools_sort_index
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --out=samtools_sort_index_%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# ==== USER SETTINGS (EDIT THESE) ====
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/samtools:1.9--h91753b0_8

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/samtools_sort_sample_list"

#reald SAMPLE_LIST
read SAMPLE SAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input SAM: $SAM"

# Output BAM in the same directory as the SAM
OUTDIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/2b.samtools_sort"
SORTED_BAM="${OUTDIR}/${SAMPLE}.sorted.bam"

# ---- SAMTOOLS SORT ----
singularity run samtools:1.9--h91753b0_8 \
  samtools sort \
    -@ "$SLURM_CPUS_PER_TASK" \
    -o "$SORTED_BAM" \
    "$SAM"

# ---- SAMTOOLS INDEX ----
singularity run samtools:1.9--h91753b0_8 \
samtools index "$SORTED_BAM"

echo "[$(date)] Finished sample: $SAMPLE"
