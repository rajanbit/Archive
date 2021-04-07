# Bisulfite-sequencing-data-analysis
Install zlib1g-dev library
```bash
$ sudo apt install zlib1g-dev
```
Download latest GSL from http://ftpmirror.gnu.org/gsl/ or `ftp://ftp.gnu.org/gnu/gsl/`

Unpack archive
```bash
$ tar -zxvf gsl-latest.tar.gz
```
Enter the gsl-2.6 directory ```$ cd gsl-2.6/``` and execute the following codes
```bash
$ mkdir /home/rajan/gsl
$ ./configure --prefix=/home/rajan/gsl
$ make
$ make check
$ make install
```
Download methpipe-4.1.1.tar.gz from https://github.com/smithlabcode/methpipe/releases/download/v4.1.1/methpipe-4.1.1.tar.gz

Unpack archive
```bash
$ tar -zxvf methpipe-4.1.1.tar.gz
```
Enter the methpipe-4.1.1 directory ```$ cd methpipe-4.1.1/``` and execute the following codes
```bash
$ mkdir build && cd build
$ ../configure
$ ../configure --prefix=/home/rajan/methpipe
$ make
$ make install
```
Download walt from https://github.com/smithlabcode/walt/archive/master.zip or https://github.com/smithlabcode/walt

Extract and rename it *walt*

Enter the *walt* directory ```$ cd walt/``` and execute the following codes
```bash
$ make all
$ make install
$ cd bin
```
Copy and paste EXPERIMENT_1 folder (containing reads folder(containing _1 and _2 reads) and reference_genome) into the bin of *walt*

Execute the following codes to make index for mapping
```bash
$ ./makedb -c EXPERIMENT_1/MTBS.fa -o MTBS.dbindex
```
Enter the EXPERIMENT_1 folder `$ cd EXPERIMENT_1/` and execute the following codes
```bash
$ mkdir reads_split
$ for i in reads/*.fastq; do \
split -a 3 -d -l 4000000 ${i} reads_split/$(basename $i); done
$ cd ..
```
Execute the following codes to make mapped reads files ( *.mr suffix)
```bash
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS0_1.fastq -2 EXPERIMENT_1/reads_split/MTBS0_2.fastq -o MTBS0.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS1_1.fastq -2 EXPERIMENT_1/reads_split/MTBS1_2.fastq -o MTBS1.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS2_1.fastq -2 EXPERIMENT_1/reads_split/MTBS2_2.fastq -o MTBS2.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS3_1.fastq -2 EXPERIMENT_1/reads_split/MTBS3_2.fastq -o MTBS3.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS4_1.fastq -2 EXPERIMENT_1/reads_split/MTBS4_2.fastq -o MTBS4.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS5_1.fastq -2 EXPERIMENT_1/reads_split/MTBS5_2.fastq -o MTBS5.mr
$ ./walt -i MTBS.dbindex -1 EXPERIMENT_1/reads_split/MTBS6_1.fastq -2 EXPERIMENT_1/reads_split/MTBS6_2.fastq -o MTBS6.mr
```
Merge all the mapped reads files ( *.mr suffix) and (*.mr.mapstats)
```bash
$ cat *.mr > MTBS.mr
$ cat *.mapstats > MTBS.mr.mapstats
```
Make a folder RESULT_MAPPING_READS, copy and paste MTBS.mr, MTBS.mr.mapstats and MTBS.fa files in it

Copy and paste RESULT_MAPPING_READS folder inside the bin of methpipe, located in the home directory

Sorted the reads inside the reads file ( *.mr suffix)
```bash
$ cd RESULT_MAPPING_READS/
$ LC_ALL=C sort -k 1,1 -k 2,2n -k 3,3n -k 6,6 \-o MTBS.mr.sorted_start MTBS.mr
$ cd ..
```
Removing read duplicates, or reads that were mapped to identical genomic locations
```bash
$ ./duplicate-remover -S RESULT_MAPPING_READS/MTBS_dremove_stat.txt \-o RESULT_MAPPING_READS/MTBS.mr.dremove RESULT_MAPPING_READS/MTBS.mr.sorted_start
```
From MTBS.fa file remove ">" and extra details (header should only contain Accession No e.g. NC_000000.3)

Estimating bisulfite conversion rate
```bash
$ ./bsrate -c RESULT_MAPPING_READS/ -o RESULT_MAPPING_READS/MTBS.bsrate RESULT_MAPPING_READS/MTBS.mr.dremoved_start
```
Computing single-site methylation levels
```bash
$ ./methcounts -c RESULT_MAPPING_READS/ -o RESULT_MAPPING_READS/MTBS.meth RESULT_MAPPING_READS/MTBS.mr.sorted_start
```
Make a directory My_Data (containing MTBS.fa and MTBS.meth) at the location of BatMeth2

Make index for BatMeth2
```bash
$ ./BatMeth2/bin/BatMeth2 build_index My_Data/MTBS.fa 
```
Converting Methpipe data format to BatMeth2 data format
```bash
$ sed -i 's/CpG/CG/g' MTBS.meth 
$ sed -i 's/CXG/CHG/g' MTBS.meth
$ awk '{ print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $6 "\t"$5*$6 "\t" $5 }' ./My_Data/MTBS.meth | column -t > ./My_Data/meth.methratio.txt
```
Download GFF file for MTBS genome, extract it and paste it inside My_Data

DNA methylation level distribution on gene
```bash
$ ./BatMeth2/bin/BatMeth2 annoation -o meth -G ./My_Data/MTBS.fa -gff ./My_Data/MTBS.gff -m My_Data/meth.methratio.txt -B -P --TSS --TSS --GENE
```
DNA methylation visualization
```bash
$ ./BatMeth2/bin/BatMeth2 methyPlot meth.methBins.txt meth.Methygenome.pdf 0.025 meth.Methylevel.1.txt meth.function.pdf TSS TSS meth.AverMethylevel.1.txt meth.Methenrich.pdf meth.annoDensity.1.txt meth.density.pdf meth meth.mCdensity.txt meth.mCdensity.pdf meth.mCcatero.txt jcmeth.mCcatero.pdf 0.6 0.1 0.1
```
