#!/bin/bash
#SBATCH --job-name=Qualimap_QC
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --out=qualimap_%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail

# ==== MODULE ====
module load singularity/4.1.0-slurm


#set SAMPLE_LIST
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/sample_list_RG"

#reald SAMPLE_LIST
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input SAM: $BAM"

IN_BAM="$BAM"
OUT_DIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/5b.qualimap_QC/${SAMPLE}"
OUT_FILE="${OUT_DIR}/${SAMPLE}.pdf"
mkdir -p "$OUT_DIR"

echo "Input BAM: $IN_BAM"

# ==== RUN Qualimap ====
unset DISPLAY
singularity run qualimap:2.3--hdfd78af_0 \
  qualimap bamqc \
    --java-mem-size=4G \
    -bam "$BAM" \
    -outdir "$OUT_DIR" \
    #-outfile "$OUT_FILE" \
    -nt 8
