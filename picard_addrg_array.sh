#!/bin/bash
#SBATCH --job-name=picard_addrg
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --out=markdups_index_%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/picard:3.4.0--hdfd78af_0

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/sample_list_addrg"

#reald SAMPLE_LIST
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input SAM: $BAM"

# variables
IN_BAM="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/3b.sort_removeDuplicates/${SAMPLE}.markdup.bam"
OUT_DIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/4b.readgroups"
OUT_BAM="${OUT_DIR}/${SAMPLE}.final.rg.bam"

echo "Input BAM: $IN_BAM"
echo "Output BAM: $OUT_BAM"

# ==== RUN AddOrReplaceReadGroups ====
singularity run picard:3.4.0--hdfd78af_0 \
  picard AddOrReplaceReadGroups \
    I="${IN_BAM}" \
    O="${OUT_BAM}" \
    RGID="${SAMPLE}" \
    RGLB="lib1" \
    RGPL="ILLUMINA" \
    RGPU="unit1" \
    RGSM="${SAMPLE}" \
    CREATE_INDEX=true 

    echo "AddOrReplaceReadGroups completed successfully for ${SAMPLE}."