#!/bin/bash
#SBATCH --job-name=mashtree
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=4:00:00
#SBATCH --output=mashtree_%j.out
#SBATCH --error=mashtree_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm

singularity pull --force https://depot.galaxyproject.org/singularity/mashtree:1.4.6--pl5321h7b50bb2_3

singularity run mashtree:1.4.6--pl5321h7b50bb2_3 \
    mashtree --numcpus "${SLURM_CPUS_PER_TASK}" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/424_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/424_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/423_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/423_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/422_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/422_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/404_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/404_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/32-2_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/32-2_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/23-060_R2_fastp.fq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/23-060_R1_fastp.fq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/110FT170Azo_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/110FT170Azo_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/104_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/104_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/103_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/103_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/080_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/080_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/068_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/068_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/046_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/046_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/015_R2.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/015_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/010_R1.fastq.gz" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/raw_fastq/010_R2.fastq.gz" > /scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/WPM_mashtree.dnd

    echo "Done: WPM_mashtree.dnd"