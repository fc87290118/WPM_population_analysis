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

FASTA="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/060.flye.corrected.medaka.ntLink.k25.w300.rounds5.scaffolds.gap_fill.polypolish.fasta"
GenotypeGVCF="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/genotypeGVCF.vcf.gz"
OUTPUT_FILE="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/8b.VariantFiltration/genotypeGVCF.filtered_all.vcf.gz"

echo "[$(date)] Filtering variants from: $GenotypeGVCF"
echo "Output will be written to: $OUTPUT_FILE"

# ==== RUN GATK VariantFiltration ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
  gatk VariantFiltration \
    -R "$FASTA" \
    -V "$GenotypeGVCF" \
    --filter-name "QUAL450"        --filter-expression "QUAL < 450.0" \
    --filter-name "QD20"           --filter-expression "QD < 20.0" \
    --filter-name "MQ30"           --filter-expression "MQ < 30.0" \
    --filter-name "FS0.1"          --filter-expression "FS > 0.1" \
    --filter-name "BaseQRankSum"   --filter-expression "BaseQRankSum < -2.0 || BaseQRankSum > 2.0" \
    --filter-name "MQRankSum"      --filter-expression "MQRankSum < -2.0 || MQRankSum > 2.0" \
    --filter-name "ReadPosRankSum" --filter-expression "ReadPosRankSum < -2.0 || ReadPosRankSum > 2.0" \
    -O "$OUTPUT_FILE"
    
echo "[$(date)] VariantFiltration completed successfully!"