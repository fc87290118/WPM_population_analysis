#!/bin/bash
#SBATCH --job-name=GATK_HaplotypeCaller
#SBATCH --cpus-per-task=2
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --out=HaplotypeCaller_%A_%a.out
#SBATCH --array=2-626
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142


set -euo pipefail
# ==== MODULE ====
module load singularity/4.1.0-slurm
#singularity pull --force https://depot.galaxyproject.org/singularity/gatk4:4.6.2.0--py310hdfd78af_1

#set SAMPLE_LIST
SAMPLE_LIST="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_haplotypecaller"

#reald SAMPLE_LIST
read SAMPLE BAM <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")"

echo "[$(date)] Processing sample: $SAMPLE"
echo "Input BAM: $BAM"

# variables
OUT_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/5b.HaplotypeCaller"
OUT_FILE="${OUT_DIR}/${SAMPLE}.g.vcf.gz"
FASTA="/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/Bgt_USA_2_genome_v1.fasta"

echo "Input BAM: $BAM"
echo "Reference FASTA: $FASTA"
echo "Output gVCF: $OUT_FILE"

# ==== RUN GATK HaplotypeCaller ====
singularity run gatk4:4.6.2.0--py310hdfd78af_1 \
   gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R "$FASTA" \
   -I "$BAM" \
   -O "$OUT_FILE" \
   -ERC GVCF \
   -ploidy 1

echo "[$(date)] Finished sample: $SAMPLE"