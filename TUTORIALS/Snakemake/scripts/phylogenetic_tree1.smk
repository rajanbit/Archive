# Snakemake script for phylogenetic tree construction from fasta records

prefix="tree"

# Create multi-fasta file from fasta records
rule fasta2mfasta:
	input: "seq"
	output: "seq.mfasta"
	shell: "cat {input}/*.fasta > {output}"

# Perform multiple sequence alignment (MSA)
rule mfasta2aln:
	input: "seq.mfasta"
	output: "seq.mafft"
	shell: "mafft --auto {input} > {output}"

# Perform phylogenetic tree construction
rule aln2tree:
	input: "seq.mafft"
	output: "tree.raxml.support"
	threads: 8
	shell: "raxml-ng --msa {input} --all --model GTR+G --prefix {prefix} --threads 8 --seed 12345 -bs-tree 100"

# Usage: $ snakemake -s phylogenetic_tree1.smk tree.raxml.support
