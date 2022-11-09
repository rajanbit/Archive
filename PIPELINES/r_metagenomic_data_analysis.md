# 16S rRNA Metagenomic Data Analysis Using R

### Requirements:
- Linux OS
- R version 4.2
- rBLAST
- taxonomizr
- parallel
- ggplot2
- forcats

### Installation:
Creating an environment and installing R
```
$ conda create -n metagenomics -c conda-forge r-base=4.2
$ conda activate metagenomics
```
Installing rBLAST package
```
$ R
> if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
> BiocManager::install("Biostrings")
$ git clone https://github.com/mhahsler/rBLAST.git
$ cd rBLAST
$ R CMD build rBLAST
$ R CMD INSTALL rBLAST
```
Installing taxonomizr, parallel, ggplot2 and forcats packages
```
$ R
> install.packages("taxonomizr")
> install.packages("parallel")
> install.packages("ggplot2")
> install.packages("forcats")
```

### Pipeline

1. Data download
```
## 16S rRNA metagenomic reads
$ wget https://docs.qiime2.org/2021.11/data/tutorials/moving-pictures-usage/emp-single-end-sequences.zip
## Reference 16S rRNA sequence for database construction
# Download 16S RefSeq Nucleotide sequence from https://www.ncbi.nlm.nih.gov/refseq/targetedloci/16S_process/
```
2. Filtering and organizing datasets
```
$ unzip emp-single-end-sequences.zip
$ gunzip sequences.fastq.gz
$ sed 's/@HWI.*/@HWIEAS4400386/g' sequences.fastq | paste - - - - | awk -F"\t" 'BEGIN{c=0}//{c++}{print $1c"\n"$2"\n"$3"\n"$4}' > 16S_rRNA_test_data.fq
```
3. Loading packages
```
> library(rBLAST)
> library(taxonomizr)
> library(parallel)
> library(ggplot2)
> library(forcats)
```
4. Input metagenomic reads
```
> fq <- readDNAStringSet('16S_rRNA_test_data.fq', format = 'fastq')
```
5. Creating reference database
```
> reference <- 'sequence.fasta'
makeblastdb(reference, dbtype='nucl')
bl <- blast(db=reference, type='blastn')
```
6. Function to run blast in parallel
```
> parpredict <- function(x){
  return(predict(bl, x, BLAST_args="-max_target_seqs 100000000"))
}
```
7. 
