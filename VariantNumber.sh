#!/bin/bash
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/bcftools:1.9--ha228f0b_4

# Count PASS variants after SelectVariants
PASS_COUNT="$(singularity run bcftools:1.9--ha228f0b_4 \
  bcftools view -H /scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/snps_pass_variantfiltration.vcf.gz | wc -l)"

# Count total variants after VariantFiltration
TOTAL_COUNT="$(singularity run bcftools:1.9--ha228f0b_4 \
  bcftools view -H /scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/genotypeGVCF.filtered_all.vcf.gz | wc -l)"

echo "================ VARIANT COUNTS ================"
echo "PASS SNPs after SelectVariants:       $PASS_COUNT"
echo "Total variants after VariantFiltration: $TOTAL_COUNT"
echo "Filtered variants:                    $((TOTAL_COUNT - PASS_COUNT))"
echo "================================================"