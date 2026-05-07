#!/bin/bash
#SBATCH --job-name=VariantFiltration
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=VariantFiltration_%j.out
#SBATCH --error=VariantFiltration_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

REF="/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/Bgt_USA_2_genome_v1.fasta"
IN_VCF="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/genotypeGVCF_filtered_all.vcf.gz"
OUT_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration"

echo "[$(date)] Input VCF: $IN_VCF"

# ==== 1) SNPs: PASS only ====
echo "[$(date)] Selecting PASS SNPs..."
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk --java-options "-Xmx16g" SelectVariants \
    -R "$REF" \
    -V "$IN_VCF" \
    --select-type-to-include SNP \
    --exclude-filtered true \
    -O "${OUT_DIR}/snps_pass_variantfiltration.vcf.gz"

# ==== 2) INDELs: PASS only ====
echo "[$(date)] Selecting PASS INDELs..."
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk --java-options "-Xmx16g" SelectVariants \
    -R "$REF" \
    -V "$IN_VCF" \
    --select-type-to-include INDEL \
    --exclude-filtered true \
    -O "${OUT_DIR}/indels_pass_variantfiltration.vcf.gz"

echo "[$(date)] Done."
echo "  SNPs  -> ${OUT_DIR}/snps_pass_variantfiltration.vcf.gz"
echo "  INDELs -> ${OUT_DIR}/indels_pass_variantfiltration.vcf.gz"

# ==== 3) Count variants (SNPs + INDELs) ====
echo "[$(date)] Counting variants..."

module load singularity/4.1.0-slurm  # ensure bcftools container uses same module
singularity pull --force https://depot.galaxyproject.org/singularity/bcftools:1.9--ha228f0b_4

SNP_COUNT=$(singularity run bcftools:1.9--ha228f0b_4 \
    bcftools view -H "${OUT_DIR}/snps_pass_variantfiltration.vcf.gz" | wc -l)

INDEL_COUNT=$(singularity run bcftools:1.9--ha228f0b_4 \
    bcftools view -H "${OUT_DIR}/indels_pass_variantfiltration.vcf.gz" | wc -l)

# ==== Summary ====
echo "================ VARIANT COUNTS ================"
echo "PASS SNPs:     $SNP_COUNT"
echo "PASS INDELs:   $INDEL_COUNT"
echo "================================================"

echo "[$(date)] Done."
