# TAC-seq data analysis
This repository contains the sequencing data analysis software for TAC-seq.

#### Requirements
* Linux-based OS
* [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit)
* [Git](https://git-scm.com/)

#### Setup
Use the following commands to setup TAC-seq data analysis software on terminal:
1. Install [FASTX-Toolkit](http://hannonlab.cshl.edu/fastx_toolkit/index.html)
2. Install [Git](https://git-scm.com/)
3. Download the analysis software using Git: `git clone https://github.com/hindrek/TAC-seq-data-analysis`
4. Navigate to analysis location: `cd TAC-seq-data-analysis`
5. Make `tacseq` executable: `chmod +x tacseq`

### Usage
#### `tacseq [options] <command>`
Analyze TAC-seq data.

options:
* `-h` display help and exit

commands:
* `prep` prepare samples (FASTQ files) for counting
* `count` count reads and molecules per sample and target

#### `tacseq prep [options]`
Prepare samples (FASTQ files) for counting.

mandatory:
* `-i` input file: gzip compressed/uncompressed FASTQ file or '-' as standard input (stdin)
* `-t` target file: target file format is based on [FASTX Barcode Splitter](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastx_barcode_splitter_usage) barcode file format
* `-o` output directory

optional:
* `-h` display help and exit
* `-m` mismatches: number of allowed mismatches per target sequence (default: 5)

#### `tacseq count [options]`
Count reads and molecules per sample and target.

mandatory:
* `-i` input directory: `tacseq prep` output directory

optional:
* `-h` display help and exit
* `-u` UMI threshold (default: 2)

#### Target file format
Target file is a text file which contains a list of targets. Each line has to contain a target ID (must be alphanumeric) which is followed by the target sequence (only A, C, G and T characters are allowed). Target ID and sequence are separated by a TAB character.

Target file example:

    TARGET1 TAGGATAGGTGGATTCGGGAACTCCCCGATAGTTTTGTCACATCGACATACTAA
    TARGET2 CCAAAGCTTCAACGGACATAGTGTACATACCTACCGTGTTTCCCAGCACCTTCC
    TARGET3 CTGCTGTTGCCGCCTGGGGTTTACGCGTGTTGGAGATTGAGTAGCCTCCTCGGC

### Output
`tacseq prep` outputs a directory for each sample with:
* 3 sub-directories with files for each target:
	* loci
	* umis
	* merged
* 2 intermediate files:
	* trimmed.fasta
	* umi_joined.fasta

`tacseq count` outputs read and molecule counts per target for each sample.

### Run example
* Step 1 - prepare samples:
`./tacseq prep -i example/samples/sample1/sample1.fastq.gz -t example/targets.txt -o example/output/sample1/ -m 5`
* Step 2 - count molecules and write results to `counts.tsv` file:
`./tacseq count -i output/sample1/ -u 2 > counts.tsv`
