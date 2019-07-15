#!/bin/bash

# read arguments
INPUT="$1"  # compressed/uncompressed FASTQ files
TARGET="$2"  # target file, target file format is based on FASTX Barcode Splitter barcode file format (http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage)
OUTPUT="$3"
MISMATCHES="$4"  # number of allowed mismatches per target sequence

mkdir "$OUTPUT"

# convert FASTQ to FASTA, trim to 62 bp, keep 62 bp reads
zcat -f "$INPUT" | fastq_to_fasta -rnv -Q33 | fastx_trimmer -l 62 -v | fastx_clipper -a X -l 62 -n -v > "$OUTPUT"/trimmed.fasta

# join UMI subsequences
awk '{if (/^>/) print $0; else printf "%s%s%s\n", substr($0,1,4), substr($0,59,4), substr($0,5,54)}' "$OUTPUT"/trimmed.fasta > "$OUTPUT"/umi_joined.fasta
   
# demultiplex by locus
mkdir "$OUTPUT"/loci
cat "$OUTPUT"/umi_joined.fasta | fastx_barcode_splitter.pl --bcfile "$TARGET" --prefix "$OUTPUT"/loci/ --suffix ".fasta" --eol --mismatches $MISMATCHES --partial 0
   
# trim target sequence (54 bp), remove UMI with N
mkdir "$OUTPUT"/umis
for i in "$OUTPUT"/loci/*.fasta; do
	locus=$(basename "$i" ".fasta")
	fastx_trimmer -t 54 -v -i "$i" | fastx_clipper -a X -l 6 -v > "$OUTPUT"/umis/"$locus".umi.fasta
done
   
# merge identical UMIs
mkdir "$OUTPUT"/merged
for i in "$OUTPUT"/umis/*.umi.fasta; do
	locus=$(basename "$i" ".umi.fasta")
	fastx_collapser -v -i "$i" > "$OUTPUT"/merged/"$locus".merged.fasta
done
