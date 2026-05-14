#!/bin/bash
#SBATCH --job-name=biallelic_addID
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=biallelic_addID_%j.out
#SBATCH --error=biallelic_addID_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm
# singularity pull --force https://depot.galaxyproject.org/singularity/bcftools:1.9--ha228f0b_4
# singularity pull --force https://depot.galaxyproject.org/singularity/plink:1.9.0b.7.7--h7b50bb2_0
# singularity pull --force https://depot.galaxyproject.org/singularity/vcftools:0.1.17--pl5321h077b44d_0
# singularity pull --force https://depot.galaxyproject.org/singularity/htslib:1.9--hc238db4_4

# 0) Paths
VCF_BIALLELIC="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/9b.GenotypeFiltration/snps_biallelic.recode.vcf.gz"
WORK_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/10b.LDpruned"
mkdir -p "$WORK_DIR"

# 1) Add IDs to biallelic VCF (if not yet done)
VCF_ID="snps_biallelic_withIDs.vcf.gz"

echo "[$(date)] Adding IDs to biallelic VCF..."
singularity run bcftools:1.9--ha228f0b_4 \
  bcftools annotate --set-id +'%CHROM\_%POS\_%REF\_%FIRST_ALT' \
    -Oz -o "$VCF_ID" "$VCF_BIALLELIC"

singularity run htslib:1.9--hc238db4_4 \
  tabix -p vcf "$VCF_ID"


