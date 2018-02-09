# TAC-seq data analysis

This repository contains the sequencing data analysis software for TAC-seq.

## Requirements
* Linux-based OS (preferably [Ubuntu](https://www.ubuntu.com/desktop) 16.04). If you are running 64-bit version of Windows 10 you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
* [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit). On Ubuntu 16.04 you can use commands `sudo apt-get update` and `sudo apt-get install fastx-toolkit`to install it.
* [Git](https://git-scm.com/). On Ubuntu 16.04 you can use command`sudo apt-get install git` to install git.
## Quick start guide
* Download the analysis software: `git clone https://github.com/cchtEE/TAC-seq-data-analysis.git`
* Navigate to analysis location: `cd TAC-seq-data-analysis`
* Run analysis: `./run.sh`

## Target file format
Target file is a text file which contains a list of targets. Each line has to contain a target ID (must be alphanumeric) which is followed by the target sequence (only A, C, G and T characters). Target ID and sequence are separated by a TAB character.

Target file example:

    TARGET1 GATCT
    TARGET2 ATCGT
    TARGET3 GTGAT
    
