#!/bin/bash
#SBATCH --job-name=GenotypeGVCFs
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=3-00:00:00
#SBATCH --partition=long
#SBATCH --output=GenotypeGVCFs_%j.out
#SBATCH --error=GenotypeGVCFs_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142


set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

GVCF="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/7b.GenotypeGVCFs/genotypeGVCF.v3.vcf.gz"
OUTPUT_FILE="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/7b.GenotypeGVCFs/genotypeGVCF.v3.vcf.gz"
FASTA="/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/Bgt_USA_2_genome_v1.fasta"

echo "[$(date)] Running GenotypeGVCFs on:"
echo "  GVCF: $GVCF"
echo "  FASTA: $FASTA"
echo "  Output: $OUTPUT_FILE"

# ==== INDEX ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk IndexFeatureFile \
    -I "$GVCF"

# ==== RUN GATK GenotypeGVCF ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk --java-options "-Xmx48g" GenotypeGVCFs \
    -R "$FASTA" \
    -V "$GVCF" \
    -O "$OUTPUT_FILE" \
    --max-alternate-alleles 4

echo "[$(date)] GenotypeGVCF susscessful"
