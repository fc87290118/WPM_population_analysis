#!/bin/bash
#SBATCH --job-name=PLINK
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=4:00:00
#SBATCH --output=PLINK_%j.out
#SBATCH --error=PLINK_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail

module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/plink:1.9.0b.7.7--h7b50bb2_0

# ==== INPUT ====
IN_VCF_FILTERED="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/9b.bcftools/snps_mm90_only.vcf.gz"

# ==== OUTPUT PREFIXES ====
OUT_PREFIX_MAF="WPM_maf05"
OUT_PREFIX_MAF_SORTED="${OUT_PREFIX_MAF}_sorted"
OUT_PREFIX_LD="${OUT_PREFIX_MAF_SORTED}_ld"
OUT_PREFIX_LD_PRUNED="${OUT_PREFIX_MAF_SORTED}_ld_pruned"

# 1) Convert filtered SNP VCF to PLINK binary, applying MAF > 0.05
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
    plink \
    --vcf "$IN_VCF_FILTERED" \
    --double-id \
    --allow-extra-chr \
    --maf 0.05 \
    --make-bed \
    --out "${OUT_PREFIX_MAF}"

# 1b) Sort .bim/.bed/.fam to satisfy LD-based pruning requirement
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
    plink \
    --bfile "${OUT_PREFIX_MAF}" \
    --allow-extra-chr \
    --make-bed \
    --out "${OUT_PREFIX_MAF_SORTED}"

# 2) LD prune on the MAF-filtered, sorted SNPs
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
    plink \
    --bfile "${OUT_PREFIX_MAF_SORTED}" \
    --allow-extra-chr \
    --indep-pairwise 50 10 0.1 \
    --out "${OUT_PREFIX_LD}"

# 3) Create the final LD-pruned, MAF-filtered dataset
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
    plink \
    --bfile "${OUT_PREFIX_MAF_SORTED}" \
    --allow-extra-chr \
    --extract "${OUT_PREFIX_LD}.prune.in" \
    --make-bed \
    --out "${OUT_PREFIX_LD_PRUNED}"

# 4) Export the final LD-pruned, MAF-filtered dataset to VCF
singularity run plink:1.9.0b.7.7--h7b50bb2_0 \
    plink \
    --bfile "${OUT_PREFIX_LD_PRUNED}" \
    --allow-extra-chr \
    --recode vcf \
    --out "${OUT_PREFIX_LD_PRUNED}"

echo "[$(date)] Finished LD pruning and VCF export."

