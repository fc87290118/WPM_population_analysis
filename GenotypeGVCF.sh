#!/bin/bash
#SBATCH --job-name=GenotypeGVCFs
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=GenotypeGVCFs_%j.out
#SBATCH --error=GenotypeGVCFs_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

GVCF="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/combined_batch1.g.vcf.gz"
OUTPUT_FILE="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/genotypeGVCF.vcf.gz"
FASTA="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/060.flye.corrected.medaka.ntLink.k25.w300.rounds5.scaffolds.gap_fill.polypolish.fasta"

echo "[$(date)] Running GenotypeGVCFs on:"
echo "  GVCF: $GVCF"
echo "  FASTA: $FASTA"
echo "  Output: $OUTPUT_FILE"

# ==== RUN GATK GenotypeGVCF ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
     gatk --java-options "-Xmx4g" GenotypeGVCFs \
    -R "$FASTA" \
    -V "$GVCF" \
    -O "$OUTPUT_FILE" \
    --max-alternate-alleles 4

      echo "[$(date)] GenotypeGVCF susscessful"