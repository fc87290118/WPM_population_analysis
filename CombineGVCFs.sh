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
GVCF_LIST="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/gvcf_list"
OUT_FILE="/scratch/y95/gracefang/WPM_project/WPM_population_genetics/7b.GVCF/combined_batch1.g.vcf.gz"

# Read all gVCF paths into an array
mapfile -t GVCFS < "$GVCF_LIST"

# Build the --variant args
VARIANT_ARGS=()
for v in "${GVCFS[@]}"; do
  VARIANT_ARGS+=( --variant "$v" )
done

echo "Combining ${#GVCFS[@]} gVCFs..."
printf '  %s\n' "${GVCFS[@]}"


# ==== RUN GATK HaplotypeCaller ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
    gatk CombineGVCFs \
    -R "$REF" \
    "${VARIANT_ARGS[@]}" \
    -O "$OUT_FILE"

    echo "Done. Output: $OUT"