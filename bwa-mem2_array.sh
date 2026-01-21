#!/bin/bash
#SBATCH --job-name=bwa-mem2
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=1-00:00:00
#SBATCH --out=%A_%a.out
#SBATCH --array=1-14
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=END,FAIL

set -euo pipefail

#singularity
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/bwa-mem2:2.3--he70b90d_0


#set SAMPLE_LIST
SAMPLE_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/sample_list_fastp"

#reald SAMPLE_LIST
read SAMPLE R1 R2 FASTA <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

#variables
OUTDIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/1b.bwa-mem2"
OUT="${OUTDIR}/${SAMPLE}.bwa_alnPE.sam"
RG="@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA"

echo "Running bwa-mem2 on $SAMPLE"
echo "R1 = $R1"
echo "R2 = $R2"

# index (only needed once; safe to rerun)
singularity run bwa-mem2:2.3--he70b90d_0 bwa-mem2 index "$FASTA"

# IMPORTANT: include the reference FASTA right after 'mem'
# (add threads and a minimal read group to be safe)
singularity run bwa-mem2:2.3--he70b90d_0 bwa-mem2 mem -M -t "$SLURM_CPUS_PER_TASK" -R "$RG" "$FASTA" "$R1" "$R2" > "$OUT"