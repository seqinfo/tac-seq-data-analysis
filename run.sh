#!/bin/bash

# read arguments for sample.sh
INPUT1=$1  # compressed/uncompressed FASTQ files
TARGET=$2  # target file format is based on FASTX Barcode Splitter barcode file format (http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage)
OUTPUT=$3
MISMATCHES=$4  # number of allowed mismatches per target sequence

# read arguments for count.sh
INPUT2=$OUTPUT  # sample.sh output folder
UMI=$5  # UMI threshold

source sample.sh "$INPUT1" $TARGET $OUTPUT $MISMATCHES
source count.sh $INPUT2 $UMI > $OUTPUT/counts_UMI$UMI.tsv
echo "results are in $OUTPUT/counts_UMI$UMI.tsv"
