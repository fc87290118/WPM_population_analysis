#!/bin/bash
#SBATCH --job-name=mashtree_ONT
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=4:00:00
#SBATCH --output=mashtree_ONT_%j.out
#SBATCH --error=mashtree_ONT_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL
#SBATCH --account=pawsey1142

set -euo pipefail

module load singularity/4.1.0-slurm

#singularity pull --force https://depot.galaxyproject.org/singularity/mashtree:1.4.6--pl5321h7b50bb2_3

singularity run mashtree:1.4.6--pl5321h7b50bb2_3 \
    mashtree --numcpus "${SLURM_CPUS_PER_TASK}" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/Bgt21_2_GWHFLAB00000000.1.genome.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/172.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/171.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/130.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/127.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/104.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/060.flye.corrected.medaka.ntLink.k25.w300.rounds5.scaffolds.gap_fill.polypolish.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/046.flye.medaka.fasta.k25.w300.z1000.ntLink.scaffolds.gap_fill.fa" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/GCA_905067625.1_Bgtriticale_THUN12_genome_v1_2_genomic.fna" > /scratch/pawsey1142/gracefang/WPM_project/WPM_genome/ONT_assembly/WPM_ONT_mashtree.dnd