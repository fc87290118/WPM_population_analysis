#!/bin/bash
#SBATCH --job-name=fastp_array
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --out=%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=END,FAIL

#singularity
set -euo pipefail
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/fastp:1.0.1--heae3180_0

#set variable
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/sample_list_illumina"
OUTDIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/fastp_out"
mkdir -p "$OUTDIR"

#reald SAMPLE_LIST
read SAMPLE R1 R2 FASTA <<< $(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

echo "Running fastp on $SAMPLE"
echo "R1 = $R1"
echo "R2 = $R2"

#run fastp
singularity run fastp:1.0.1--heae3180_0 \
fastp \
  -i "$R1" \
  -I "$R2" \
  -o "$OUTDIR/${SAMPLE}_R1.fastp.fq.gz" \
  -O "$OUTDIR/${SAMPLE}_R2.fastp.fq.gz" \
  -h "$OUTDIR/${SAMPLE}_fastp.html" \
  -j "$OUTDIR/${SAMPLE}_fastp.json" \
  -w "$SLURM_CPUS_PER_TASK"

echo "[DONE] $SAMPLE at $(date)"