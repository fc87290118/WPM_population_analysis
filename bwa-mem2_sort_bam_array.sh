#!/bin/bash
#SBATCH --job-name=bwa-mem2
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=1-00:00:00
#SBATCH --out=%A_%a.out
#SBATCH --array=2-666
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=END,FAIL
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm
# pull bwa
#singularity pull --force https://depot.galaxyproject.org/singularity/bwa-mem2:2.3--he70b90d_0
# pull samtools
#singularity pull --force https://depot.galaxyproject.org/singularity/samtools:1.9--h91753b0_8

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_bwa"
FASTA="/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/Bgt_USA_2_genome_v1.fasta"

#reald SAMPLE_LIST
read SAMPLE R1 R2 <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

#variables
OUTDIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/1b.bwa-mem2"
OUT="${OUTDIR}/${SAMPLE}.bwa_alnPE.sorted.bam"
RG="@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA"

echo "Running bwa-mem2 on $SAMPLE"
echo "R1 = $R1"
echo "R2 = $R2"

# index (only needed once; safe to rerun)
# singularity run bwa-mem2:2.3--he70b90d_0 bwa-mem2 index "$FASTA"

# IMPORTANT: include the reference FASTA right after 'mem'
# (add threads and a minimal read group to be safe)
# bwa-mem2 container -> samtools container, no SAM on disk
singularity run bwa-mem2:2.3--he70b90d_0 bwa-mem2 mem -M -t "$SLURM_CPUS_PER_TASK" -R "$RG" "$FASTA" "$R1" "$R2" \
  | singularity run samtools:1.9--h91753b0_8 samtools sort \
      -@ "$SLURM_CPUS_PER_TASK" \
      -o "$OUT" \
      -
