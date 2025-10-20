#!/bin/bash -l
#SBATCH -J tree
#SBATCH -o tree.out
#SBATCH -e tree.error
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --mail-type=ALL
#SBATCH -t 4:00:00
#SBATCH -A uppmax2025-2-348
#SBATCH -p core
#SBATCH -n 8

module load bioinfo-tools iqtree

iqtree2 -s all_seqs_trimmed.fasta.aln -m MFP -B 1000 -bnni -T 8