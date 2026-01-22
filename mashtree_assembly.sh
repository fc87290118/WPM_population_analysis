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

#singularity pull --force https://depot.galaxyproject.org/singularity/mashtree:1.4.6--pl5321h7b50bb2_3

singularity run mashtree:1.4.6--pl5321h7b50bb2_3 \
    mashtree --numcpus "${SLURM_CPUS_PER_TASK}" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/24PM110FT170_Azo_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/24PM104_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/24PM103_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/24PM32-2_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/23PM060_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/23PM046_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/22PM424_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/22PM423_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/22PM422_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/22PM404_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/21PM080_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/21PM068_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/20PMFRG015_final_assembly.fasta" \
    "/scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/20PMFRG010_final_assembly.fasta" > /scratch/pawsey1142/gracefang/WPM_project/WPM_genome/illumina_assembly/WPM_assembly_mashtree.dnd