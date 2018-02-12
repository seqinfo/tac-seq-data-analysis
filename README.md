# TAC-seq data analysis
This repository contains the sequencing data analysis software for TAC-seq.

## Requirements
* Linux-based OS (preferably [Ubuntu](https://www.ubuntu.com/desktop) 16.04). If you are running 64-bit version of Windows 10 you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10). Alternatively you can use [Oracle VM VirtualBox](https://www.virtualbox.org/) to run Ubuntu 16.04 inside Windows following this [guide](https://askubuntu.com/questions/142549/how-to-install-ubuntu-on-virtualbox).
* [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit)

## Setup
Use the following commands to setup TAC-seq data analysis software on Ubuntu 16.04 terminal:
1. Prepare Ubuntu for software installation: `sudo apt update`
2. Install [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit): `sudo apt install fastx-toolkit`
3. Install [git](https://git-scm.com/): `sudo apt install git`
4. Download the analysis software: `git clone https://github.com/cchtEE/TAC-seq-data-analysis.git`
5. Navigate to analysis location: `cd TAC-seq-data-analysis`
6. Make `run.sh` executable: `chmod +x run.sh`

## Run analysis
Execute `run.sh` with following arguments:
1. Input FASTQ files (supports also gzip compressed FASTQ files)
2. Target file
3. Output folder
4. Number of allowed mismatches per target sequence
5. UMI threshold

## Target file format
Target file is a text file which contains a list of targets. Each line has to contain a target ID (must be alphanumeric) which is followed by the target sequence (only A, C, G and T characters). Target ID and sequence are separated by a TAB character.

Target file example:

    TARGET1 TAGGATAGGTGGATTCGGGAACTCCCCGATAGTTTTGTCACATCGACATACTAA
    TARGET2 CCAAAGCTTCAACGGACATAGTGTACATACCTACCGTGTTTCCCAGCACCTTCC
    TARGET3 CTGCTGTTGCCGCCTGGGGTTTACGCGTGTTGGAGATTGAGTAGCCTCCTCGGC
    
## Example
`source run.sh "example/*.fastq" example/targets.txt output/ 5 2`
