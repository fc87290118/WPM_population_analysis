#!/bin/bash
#SBATCH --job-name=samtools_index_bam20Cov
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --out=index_%A_%a.out
#SBATCH --array=2-626
#SBATCH --account=pawsey1142

set -euo pipefail

LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_coverage_ge20x"

module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/samtools:1.9--h91753b0_8

read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")"

echo "[$(date)] Indexing $SAMPLE"
singularity run samtools:1.9--h91753b0_8 samtools index "$BAM"
echo "[$(date)] Done $SAMPLE"
