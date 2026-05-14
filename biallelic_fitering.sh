#!/bin/bash
#SBATCH --job-name=biallelic_filtering
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=biallelic_filtering_%j.out
#SBATCH --error=biallelic_filtering_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/vcftools:0.1.17--pl5321h077b44d_0
#singularity pull --force https://depot.galaxyproject.org/singularity/htslib:1.9--hc238db4_4

VCF_IN="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/9b.GenotypeFiltration/snps_pass_maxmissing0.9.recode.vcf.gz"
OUT_BASE="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/9b.GenotypeFiltration/"

singularity run vcftools:0.1.17--pl5321h077b44d_0 \
  vcftools --gzvcf "$VCF_IN" \
    --max-alleles 2 \
    --recode --recode-INFO-all \
    --out "${OUT_BASE}/snps_biallelic"

# compress + index
singularity run htslib:1.9--hc238db4_4 bgzip -f "${OUT_BASE}/snps_biallelic.recode.vcf"
singularity run htslib:1.9--hc238db4_4 tabix -p vcf "${OUT_BASE}/snps_biallelic.recode.vcf.gz"
