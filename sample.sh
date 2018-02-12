#!/bin/bash

# read arguments
INPUT=$1  # compressed/uncompressed FASTQ files
TARGET=$2  # target file format is based on FASTX Barcode Splitter barcode file format (http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage)
OUTPUT=$3
MISMATCHES=$4  # number of allowed mismatches per target sequence

mkdir $OUTPUT
for i in $INPUT; do
	# compressed FASTQ
	if [[ $i == *.gz ]]; then
		# convert FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
		sample=$(basename $i .fastq.gz)  # remove .fastq.gz from sample name
		mkdir $OUTPUT/$sample
		zcat $i | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > $OUTPUT/$sample/trimmed.fasta
	
	# uncompressed FASTQ
	else
		# convert FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
		sample=$(basename $i .fastq)  # remove .fastq from sample name
		mkdir $OUTPUT/$sample
		cat $i | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > $OUTPUT/$sample/trimmed.fasta
	fi
	
	# join UMI subsequences
	awk '{if (/^>/) print $0; else printf "%s%s%s\n", substr($0,1,4), substr($0,59,4), substr($0,5,54)}' $OUTPUT/$sample/trimmed.fasta > $OUTPUT/$sample/umi_joined.fasta
    
	# demultiplex by locus
	mkdir $OUTPUT/$sample/loci
	cat $OUTPUT/$sample/umi_joined.fasta | fastx_barcode_splitter.pl --bcfile $TARGET --prefix $OUTPUT/$sample/loci/ --suffix ".fasta" --eol --mismatches $MISMATCHES --partial 0
    
	# trim target sequence (54 bp), remove UMI with N
	mkdir $OUTPUT/$sample/umis
	for i in $OUTPUT/$sample/loci/*.fasta; do
		locus=$(basename $i .fasta)
		fastx_trimmer -t 54 -v -i $i | fastx_clipper -a X -l 6 -v > $OUTPUT/$sample/umis/$locus.umi.fasta
	done
    
	# merge identical UMIs
	mkdir $OUTPUT/$sample/merged
	for i in $OUTPUT/$sample/umis/*.umi.fasta; do
		locus=$(basename $i .umi.fasta)
		fastx_collapser -v -i $i > $OUTPUT/$sample/merged/$locus.merged.fasta
	done
done
