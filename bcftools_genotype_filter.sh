#!/bin/bash
#SBATCH --job-name=bcftools_filters
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=04:00:00
#SBATCH --output=bcftools_filters_%j.out
#SBATCH --error=bcftools_filters_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/bcftools:1.9--ha228f0b_4
# Input and output paths
IN_VCF_FILTERED="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/snps_pass_variantfiltration.vcf.gz"
OUT_DIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/9b.bcftools"

echo "[$(date)] Input VCF: $IN_VCF_FILTERED"
echo "Output directory:   $OUT_DIR" 

# =======================
# 1) ≥ 90% genotyped SNPs
# =======================
MM90_VCF="${OUT_DIR}/snps_mm90_only.vcf.gz"

echo "[$(date)] Filtering for F_MISSING < 0.1 (≥ 90% genotyped)..."

singularity run bcftools:1.9--ha228f0b_4 \
  bcftools view \
    -i 'F_MISSING < 0.1' \
    "$IN_VCF_FILTERED" \
    -Oz -o "$MM90_VCF"

singularity run bcftools:1.9--ha228f0b_4 \
  bcftools index "$MM90_VCF"


# =======================
# 2) Biallelic SNPs only
# =======================

BIALL_VCF="${OUT_DIR}/snps_biallelic_only.vcf.gz"

echo "[$(date)] Filtering for N_ALLELES = 2 (biallelic only)..."

singularity run bcftools:1.9--ha228f0b_4 \
  bcftools view \
    --max-alleles 2 \
    "$IN_VCF_FILTERED" \
    -Oz -o "$BIALL_VCF"

singularity run bcftools:1.9--ha228f0b_4 \
  bcftools index "$BIALL_VCF"


# =======================
# Quick counts (optional)
# =======================

MM90_COUNT=$(singularity run bcftools:1.9--ha228f0b_4 bcftools view -H "$MM90_VCF" | wc -l)
BIALL_COUNT=$(singularity run bcftools:1.9--ha228f0b_4 bcftools view -H "$BIALL_VCF" | wc -l)

echo "================ VARIANT COUNTS ================"
echo "≥ 90% genotyped SNPs:   $MM90_COUNT"
echo "Biallelic SNPs only:    $BIALL_COUNT"
echo "================================================"
echo "[$(date)] Finished bcftools filtering."
