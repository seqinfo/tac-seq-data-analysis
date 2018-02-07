#!/bin/bash

#SBATCH --job-name=sample
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH --time=100:00:00

source activate pesa  # load conda environment (required software)

# arguments with default values
FASTQS=  # TODO: detect all FASTQs from bcl2fastq.sh output folder and subfolders
TARGETS=  # target file format is based on FASTX Barcode Splitter barcode file format (http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage)
OUTPUT=
MISMATCHES=5

mkdir $OUTPUT
cd $OUTPUT
for i in $FASTQS; do
	sample=$(basename $i .fastq.gz)
	mkdir $sample
	cd $sample
	
	# FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
	zcat $i | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > trimmed.fasta
    
	# join UMI subsequences
	awk '{if (/^>/) print $0; else printf "%s%s%s\n", substr($0,1,4), substr($0,59,4), substr($0,5,54)}' trimmed.fasta > umi_joined.fasta
    
	# demultiplex by locus
	mkdir loci
	cat umi_joined.fasta | fastx_barcode_splitter.pl --bcfile $TARGETS --prefix loci/ --suffix ".fasta" --eol --mismatches $MISMATCHES --partial 0
    
	# trim target sequence (54 bp), remove UMI with N
	mkdir umis
	for i in loci/*.fasta; do
		locus=$(basename $i .fasta)
		fastx_trimmer -t 54 -v -i $i | fastx_clipper -a X -l 6 -v > umis/$locus.umi.fasta
	done
    
	# merge identical UMIs
	mkdir merged
	for i in umis/*.umi.fasta; do
		locus=$(basename $i .umi.fasta)
		fastx_collapser -v -i $i > merged/$locus.merged.fasta
	done
	
	cd ..
done
