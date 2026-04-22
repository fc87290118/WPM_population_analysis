#!/bin/bash
#SBATCH --job-name=Qualimap_bamqc
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --out=qualimap_%A_%a.out
#SBATCH --array=2-626
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/qualimap:2.3--hdfd78af_0

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_qualimap"
OUT_BASE="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/4b.qualimap_QC"

#reald SAMPLE_LIST
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input BAM: $BAM"

OUT_DIR="${OUT_BASE}/${SAMPLE}.markdup_stats"
mkdir -p "$OUT_DIR"

# ==== RUN Qualimap ====
unset DISPLAY
singularity run qualimap:2.3--hdfd78af_0 \
  qualimap --java-mem-size=12G bamqc \
    -bam "$BAM" \
    -outdir "$OUT_DIR" \
    -nt "$SLURM_CPUS_PER_TASK"

echo "[$(date)] Done: $SAMPLE"
