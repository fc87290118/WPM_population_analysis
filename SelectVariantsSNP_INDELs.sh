#!/bin/bash
#SBATCH --job-name=VariantFiltration
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=VariantFiltration_%j.out
#SBATCH --error=VariantFiltration_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

REF="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/060.flye.corrected.medaka.ntLink.k25.w300.rounds5.scaffolds.gap_fill.polypolish.fasta"
IN_VCF="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/genotypeGVCF.filtered_all.vcf.gz"
OUT_DIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration"

echo "[$(date)] Input VCF: $IN_VCF"

# ==== 1) SNPs: PASS only ====
echo "[$(date)] Selecting PASS SNPs..."
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk SelectVariants \
    -R "$REF" \
    -V "$IN_VCF" \
    --select-type-to-include SNP \
    --exclude-filtered true \
    -O "${OUT_DIR}/snps_pass_variantfiltration.vcf.gz"

# ==== 2) INDELs: PASS only ====
echo "[$(date)] Selecting PASS INDELs..."
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk SelectVariants \
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
