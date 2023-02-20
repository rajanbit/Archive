# Snakemake script for generating consensus sequence from FASTQ reads

SAMPLES, = glob_wildcards("reads/{prefix}_1.fastq", "reads/{prefix}_2.fastq")

# Running fastp tool for QA and QC
rule fastp:
	input:
		r1="reads/{prefix}_1.fastq", r2="reads/{prefix}_2.fastq"
	output:
		r1="output/filtered_reads/{prefix}_1.fastq.out", r2="output/filtered_reads/{prefix}_2.fastq.out"
	shell:
		"fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2} -q 30"

# Running bwa-mem tool for reference based alignment
rule bwa_mem:
	input:
		r1="output/filtered_reads/{prefix}_1.fastq.out", r2="output/filtered_reads/{prefix}_2.fastq.out",
		ref="ref/ref.fasta"
	output:
		"output/mapped_reads/{prefix}.bam"
	shell:
		"""
		bwa index {input.ref}
		bwa mem {input.ref} {input.r1} {input.r2} | samtools view -Sb - > {output}
		"""
# Running samtools for sorting the BAM file produced by bwa-mem
rule samtools_sort:
	input:
		"output/mapped_reads/{prefix}.bam"
	output:
		"output/sorted_reads/{prefix}.bam"
	shell:
		"samtools sort -T output/sorted_reads/{wildcards.prefix} -O bam {input} > {output}"

# Running bcftools for generating consensus FASTQ file
rule bcftools_mpileup:
	input: 
		ref="ref/ref.fasta", bam="output/sorted_reads/{prefix}.bam"
	output:
		"output/consensus/{prefix}.fastq"
	shell: 
		"bcftools mpileup -Ou -f {input.ref} {input.bam} | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq > {output}"
	
# Running seqtk for generating consensus sequence
rule seqtk_consensus:
	input:
		"output/consensus/{prefix}.fastq"
	output:
		"output/consensus/{prefix}.fasta"
	shell:
		"seqtk seq -aQ64 -q30 -n N {input} > {output}"

# Usage: snakemake -s FASTQ2consensus.smk output/consensus/SRR22424777.fasta
