#!/bin/bash
#SBATCH --job-name=sra_array
#SBATCH --array=2-279
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --account=pawsey1142
#SBATCH --output=sra_%A_%a.out
#SBATCH --error=sra_%A_%a.err

set -euo pipefail

OUTDIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/Euro_WPM_rawFastq"
IDS="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/Euro_WPM_rawFastq/SRR_Acc_List.txt"
# Optional: where to store .sra downloads (keep it on scratch)
SRACACHE="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/sra_cache"

# Get SRR for this task (array=1 -> first line)
SRR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${IDS}")

# Load whatever module provides sra-tools on Setonix (if you have one).
# If you installed sra-tools in a conda env, activate it here instead.
# module load sratoolkit
# OR (example) conda activate <env>

 # 1) Download .sra robustly
# wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
# tar -vxzf sratoolkit.tar.gz

# 2) Convert to FASTQ (paired)
export PATH=$PATH:/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/tools/sratoolkit.3.4.1-ubuntu64/bin

echo "Task ${SLURM_ARRAY_TASK_ID}: ${SRR}"
echo "OUTDIR=${OUTDIR}"
echo "SRACACHE=${SRACACHE}"
date

which prefetch
which fasterq-dump

# Step 1:Download accession first
prefetch "${SRR}" \
  --output-directory "${SRACACHE}" \
  --max-size 100G

# Step 2: Move into OUTDIR (ensures output lands here)
cd "${OUTDIR}"

# Step 3: Convert to FASTQ
fasterq-dump "${SRACACHE}/${SRR}" \
  --split-files \
  --threads "${SLURM_CPUS_PER_TASK}" \
  --outdir "${OUTDIR}" \
  --temp "${SRACACHE}" \
  --progress

# Step 4: Compress FASTQ
if command -v pigz >/dev/null 2>&1; then
  pigz -p "${SLURM_CPUS_PER_TASK}" "${OUTDIR}/${SRR}"_*.fastq
else
  gzip -f "${OUTDIR}/${SRR}"_*.fastq
fi

echo "FASTQ files saved in: ${OUTDIR}"
ls -lh "${OUTDIR}/${SRR}"*

echo "Done: ${SRR}"
date