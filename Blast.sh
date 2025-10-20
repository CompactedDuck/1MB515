#!/bin/bash -l
#SBATCH -J Blast
#SBATCH -o Blast.out
#SBATCH -e Blast.error
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --mail-type=ALL
#SBATCH -t 2:00:00
#SBATCH -A uppmax2025-2-348
#SBATCH -p core
#SBATCH -n 4

#Load modules and set variables
module load bioinfo-tools blast SeqKit
INDIR="/home/matthr/Phylo/Project/Data"
QUERY="${INDIR}/1.env_seqs.fasta"
DB="/home/matthr/Phylo/Project/Data/Blast/pr2_version_5.1.0_SSU_taxo_long.fasta"

#Make a BLAST DB and run query
makeblastdb -in $DB -dbtype nucl
blastn -query $QUERY -db $DB -out env_seqs_vs_pr2.blastn -outfmt '6 std salltitles' -num_threads 4

#Retrieve the Top 10 hits for each query seqeunce
for header in $(cut -f1 env_seqs_vs_pr2.blastn | sort -u); 
do 
grep -w -m 10 "$header" env_seqs_vs_pr2.blastn | cut -f13 | sort -u >> env_seqs_vs_pr2.top10hits.list; 
done

#Get the corresponding sequences for each hit
cat $DB | seqkit grep -f env_seqs_vs_pr2.top10hits.list > env_seqs_vs_pr2.top10hits.fasta

#Combine reference sequences and environmental seqeunces
cat $QUERY env_seqs_vs_pr2.top10hits.fasta ${INDIR}/2.gen_euk_div.fasta > all_env_seqs_ref.fasta

#Remove duplicates
cat all_env_seqs_ref.fasta | seqkit rmdup -n -o all_env_seqs_ref.clean.fasta
