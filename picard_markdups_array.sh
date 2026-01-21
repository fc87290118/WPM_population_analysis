#!/bin/bash
#SBATCH --job-name=picard_markdups
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --out=markdups_index_%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail

# ==== USER SETTINGS (EDIT THESE) ====
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/picard:3.4.0--hdfd78af_0

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/sample_list_markdups"

#reald SAMPLE_LIST
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input SAM: $BAM"

# Output BAM in the same directory as the SAM
OUTDIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/3b.sort_removeDuplicates"
OUTPUT="${OUTDIR}/${SAMPLE}.markdup.bam"
METRIX="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/3b.sort_removeDuplicates/$SAMPLE.marked_dup_metrics.txt"

# run singularity
singularity run picard:3.4.0--hdfd78af_0 \
picard MarkDuplicates \
I=$BAM \
O=$OUTPUT \
M=$METRIX \
TAGGING_POLICY=All

echo "MarkDuplicates completed successfully."