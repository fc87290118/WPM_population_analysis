#!/bin/bash
#SBATCH --job-name=PLINK_LDprune_biallelic
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=PLINK_LDprune_biallelic_%j.out
#SBATCH --error=PLINK_LDprune_biallelic_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm

# ==== PATHS ====
# make sure to use the vcf file with ID added in, otherwise later pipeline will not extract pruned snps correctly
IN_VCF_FILTERED="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/script/WPM_population_analysis/snps_biallelic_withIDs.vcf.gz"
OUT_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/10b.LDpruned"
mkdir -p "$OUT_DIR"

# ==== OUTPUT PREFIXES (all created in OUT_DIR) ====
OUT_PREFIX_ALL="WPM_biallelic_all"
OUT_PREFIX_LD="${OUT_PREFIX_ALL}_ld"

# 1) Convert ID-annotated SNP VCF to PLINK binary
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
  plink \
    --vcf "$IN_VCF_FILTERED" \
    --double-id \
    --allow-extra-chr \
    --make-bed \
    --out "${OUT_PREFIX_ALL}"

# 2) LD prune on the biallelic SNPs
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
  plink \
    --bfile "${OUT_PREFIX_ALL}" \
    --allow-extra-chr \
    --indep-pairwise 50 10 0.5 \
    --out "${OUT_PREFIX_LD}"

