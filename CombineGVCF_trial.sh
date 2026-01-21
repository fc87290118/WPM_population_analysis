#!/bin/bash
#SBATCH --job-name=CombineGVCFs
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=CombineGVCFs_%j.out
#SBATCH --error=CombineGVCFs_%j.err

set -euo pipefail

module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

REF="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/060.flye.corrected.medaka.ntLink.k25.w300.rounds5.scaffolds.gap_fill.polypolish.fasta"
OUT_FILE="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/combined_batch1_trial.g.vcf.gz"



# ==== RUN GATK HaplotypeCaller ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
    gatk CombineGVCFs \
    -R "$REF" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/423.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/110FT170Azo.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/422.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/010.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/046.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/080.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/068.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/104.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/32-2.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/103.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/404.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/060.g.vcf.gz" \
    --variant "/scratch/y95/gracefang/WPM_project/WPM_population_genetics/6b.HaplotypeCaller/015.g.vcf.gz" \
    -O "$OUT_FILE"

    echo "Done. Output: $OUT_FILE"