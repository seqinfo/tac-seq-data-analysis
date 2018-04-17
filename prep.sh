#!/bin/bash

# read arguments
input=$1  # compressed/uncompressed FASTQ files
target=$2  # target file, target file format is based on FASTX Barcode Splitter barcode file format (http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage)
output=$3
mismatches=$4  # number of allowed mismatches per target sequence

mkdir $output
for i in $input; do
  # compressed FASTQ
  if [[ $i == *.gz ]]; then
    # convert FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
    sample=$(basename $i .fastq.gz)  # remove .fastq.gz from sample name
    mkdir $output/$sample
    zcat $i | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > $output/$sample/trimmed.fasta
  
  # uncompressed FASTQ
  else
    # convert FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
    sample=$(basename $i .fastq)  # remove .fastq from sample name
    mkdir $output/$sample
    cat $i | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > $output/$sample/trimmed.fasta
  fi
  
  # join UMI subsequences
  awk '{if (/^>/) print $0; else printf "%s%s%s\n", substr($0,1,4), substr($0,59,4), substr($0,5,54)}' $output/$sample/trimmed.fasta > $output/$sample/umi_joined.fasta
    
  # demultiplex by locus
  mkdir $output/$sample/loci
  cat $output/$sample/umi_joined.fasta | fastx_barcode_splitter.pl --bcfile $target --prefix $output/$sample/loci/ --suffix ".fasta" --eol --mismatches $mismatches --partial 0
    
  # trim target sequence (54 bp), remove UMI with N
  mkdir $output/$sample/umis
  for i in $output/$sample/loci/*.fasta; do
    locus=$(basename $i .fasta)
    fastx_trimmer -t 54 -v -i $i | fastx_clipper -a X -l 6 -v > $output/$sample/umis/$locus.umi.fasta
  done
    
  # merge identical UMIs
  mkdir $output/$sample/merged
  for i in $output/$sample/umis/*.umi.fasta; do
    locus=$(basename $i .umi.fasta)
    fastx_collapser -v -i $i > $output/$sample/merged/$locus.merged.fasta
  done
done
