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
7. Creating local taxonomy database
```
> dir.create('taxonomy')
> prepareDatabase('taxonomy/accessionTaxa.sql')
> prepareDatabase('accessionTaxa.sql')
> tax_db = 'taxonomy/'
> tax_db_files = list.files(tax_db, full.names = TRUE)
> nodes = tax_db_files[grepl('nodes', tax_db_files)]
> names = tax_db_files[grepl('names', tax_db_files)]
> accession = tax_db_files[grepl('accessionTaxa', tax_db_files)]
> taxaNodes<-read.nodes.sql(nodes)
> taxaNames<-read.names.sql(names)
```
8. Cluster setup
```
> clus <- makeCluster('8', type='FORK')
> splits <- clusterSplit(clus, fq[302581])
> p_cl <- parLapply(clus, splits, parpredict)
> stopCluster(clus)
> cl <- dplyr::bind_rows(p_cl)
```
9. Filtering Hits
```
> clfilt <- cl[which(cl$Perc.Ident>=95 & cl$Alignment.Length>=140),]
```
10. Extract accession IDs for blast hits
```
> accid = as.character(clfilt$SubjectID)
```
11. Extract taxonomic IDs
```
> ids<-accessionToTaxa(accid, accession)
```
12. Extract taxonomic name
```
> taxlist=getTaxonomy(ids, taxaNodes, taxaNames)
> cltax=cbind(clfilt,taxlist)
```
13. Visualization
```
> ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(family))) +
  theme(axis.text.x = element_text(angle=90))

> ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(species))) +
  theme(axis.text.x = element_text(angle=90))
```
### Reference
Adapted from @ *[https://github.com/rsh249/bio331_2021/blob/main/R/BLAST_metagenomics_demo.R](https://github.com/rsh249/bio331_2021/blob/main/R/BLAST_metagenomics_demo.R)*
