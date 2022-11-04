# 16S rRNA Database of Mycobacterium sp. 

This is a demo pipeline that covers following topics:
- Accessing sequence data from NCBI FTP site
- Creating a MySQL database
- Feeding sequence data as hash into MySQL database using python connector

#
### Requirements:
- Linux OS
- Python 3.8 or above
- MySQL 
- Python MySQL Connector
- Scripts: [extract_fasta_records.py](https://github.com/rajanbit/Bioinfo_py_Scripts/blob/master/file_handling/extract_fasta_records.py), 
[fasta2db_feed.py](https://github.com/rajanbit/Bioinfo_py_Scripts/blob/master/file_handling/fasta2db_feed.py)
#
### Pipeline:

1. Download **assembly_summary.txt** file
```
$ wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
```
2. Select rows with **Mycobacterium** genus
```
$ grep "Mycobacterium" assembly_summary.txt > mycobacterium_summary.tsv
```
3. Extract **ftp path** for each isolate
```
$ cut -f20 mycobacterium_summary.tsv > ftpfilepaths.txt
```
4. Creating **ftp file path** from ftp path
```
$ awk -F"/" '{print $10"_rna_from_genomic.fna.gz"}' ftpfilepaths.txt > filename.txt
$ paste ftpfilepaths.txt filename.txt | awk '{print $1"/"$2}' > ftp_path.txt
```
5. Downloading **rna_from_genomic.fna** file
```
$ while read line; do wget $line; done < ftp_path.txt
```
6. **Unzipping** .gz files and **merging** all data
```
$ gunzip *.gz
$ cat *.fna > rna_from_genomic.fna 
$ sed -i "s/lcl|//g" rna_from_genomic.fna
```
7. Extracting **16S rRNA gene** sequences
```

$ grep "product=16S ribosomal RNA" rna_from_genomic.fna > 16S_rRNA_ids.txt
$ sed -i "s/ .*//g" 16S_rRNA_ids.txt
$ python extract_fasta_records.py rna_from_genomic.fna 16S_rRNA_ids.txt
```
8. Create a **template database** using MySQL
```
$ sudo mysql
mysql> CREATE DATABASE 16srRNAdb;
mysql> use 16srRNAdb;
mysql> CREATE TABLE myseq(seqID varchar(50) not null, seq varchar(200) not null);
mysql> CREATE USER 'user1'@'localhost' IDENTIFIED BY '';
mysql> GRANT ALL ON 16srRNAdb.* TO 'user1'@'localhost' WITH GRANT OPTION;
```
9. **Feeding** sequence data to template database
```
$ python fasta2db_feed.py output.fasta
```
10. **Viewing** database content
```
$ sudo mysql
mysql> use 16srRNAdb;
mysql> show tables;
mysql> desc myseq;
mysql> SELECT * FROM myseq;
```
