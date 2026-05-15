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

## ============================ second half, extract pruned position and extract SNPs from vcf ====================================
# 3) Map prune.in IDs to CHROM + POS
BIM="${OUT_PREFIX_ALL}.bim"              # WPM_biallelic_all.bim
PRUNE_IN="${OUT_PREFIX_LD}.prune.in"     # WPM_biallelic_all_ld.prune.in
POS_FILE="${OUT_PREFIX_LD}.prune.in.pos" # WPM_biallelic_all_ld.prune.in.pos

awk 'NR==FNR {keep[$1]; next} ($2 in keep){print $1"\t"$4}' \
  "$PRUNE_IN" "$BIM" \
  > "$POS_FILE"

# 4) Apply pruning to the ID-annotated biallelic VCF
VCF_BIALLELIC="$IN_VCF_FILTERED"
OUT_PREFIX_VCF="${OUT_DIR}/snps_biallelic_ldpruned"

singularity run vcftools:0.1.17--pl5321h077b44d_0 \
  vcftools \
    --gzvcf "$VCF_BIALLELIC" \
    --positions "$POS_FILE" \
    --recode --recode-INFO-all \
    --out "$OUT_PREFIX_VCF"

# 5) Compress + index pruned VCF
singularity run htslib:1.9--hc238db4_4 \
  bgzip -f "${OUT_PREFIX_VCF}.recode.vcf"

singularity run htslib:1.9--hc238db4_4 \
  tabix -p vcf "${OUT_PREFIX_VCF}.recode.vcf.gz"
