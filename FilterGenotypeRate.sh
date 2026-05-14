#!/bin/bash
#SBATCH --job-name=vcftools_filterGenotypeRate
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=vcftools_filterGenotypeRate_%j.out
#SBATCH --error=vcftools_filterGenotypeRate_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/vcftools:0.1.17--pl5321h077b44d_0

VCF_IN="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/snps_pass_variantfiltration.vcf.gz"
OUT_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/9b.GenotypeFiltration"
mkdir -p "$OUT_DIR"

singularity run vcftools:0.1.17--pl5321h077b44d_0 \
  vcftools --gzvcf "$VCF_IN" \
    --max-missing 0.9 \
    --recode --recode-INFO-all \
    --out "${OUT_DIR}/snps_pass_maxmissing0.9"

# compress + index (via bcftools or htslib container; adjust as you prefer)
module load singularity/4.1.0-slurm
singularity pull --force https://depot.galaxyproject.org/singularity/bcftools:1.9--ha228f0b_4

singularity run bcftools:1.9--ha228f0b_4 \
  bgzip -f "${OUT_DIR}/snps_pass_maxmissing0.9.recode.vcf"

singularity run bcftools:1.9--ha228f0b_4 \
  tabix -p vcf "${OUT_DIR}/snps_pass_maxmissing0.9.recode.vcf.gz"