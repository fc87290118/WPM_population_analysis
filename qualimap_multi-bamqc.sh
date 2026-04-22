#!/bin/bash
#SBATCH --job-name=qualimap_multibamQC
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --out=qualimap_%j.out
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/qualimap:2.3--hdfd78af_0

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_multibamqc.tsv"
OUT_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/4b.qualimap_QC"

# ==== RUN Qualimap ====
unset DISPLAY
singularity run qualimap:2.3--hdfd78af_0 \
  qualimap --java-mem-size=24G multi-bamqc \
    -d $SAMPLE_LIST \
    -outdir $OUT_DIR