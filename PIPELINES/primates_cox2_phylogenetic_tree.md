# Primates Cytochrome C Oxidase - II (COX2) Gene Tree
## Phylogenetic tree construction using online web-servers
Phylogenetic tree is a graphical representation of evolutionary relationships between various taxa. It is commonly used in evolutionary biology, microbiology and epidemiology. Here we will try to draw the phylogenetic relationship between primates that includes Human, Apes, Old World Monkey and New World Monkey using Cytochrome C Oxidase-II (COX2) gene sequences. Cytochrome C Oxidase-II (COX2) is a mitochondrial DNA (mtDNA) encoded gene widely used for reconstructing phylogenetic relationship at different taxomonic levels. 

1. Download [Cytochrome C Oxidase-II (COX2) gene sequences](https://raw.githubusercontent.com/rajanbit/DiGeMed-Datasharing/main/Rajan/Phylogenetic_Tree_Construction/data/primates_tree/primates_cox2.fasta).

> Here we have used COX2 gene sequences for Human, Apes (Chimp, Gorilla, Orangutan & Gibbon), Old World Monkey(Baboon & Macaque) New World Monkey (Owl & Squirrel Monkey) and Mouse (as outgroup).
2. Perform Multiple Sequence Alignment (MSA) using [ClustalW](https://www.ebi.ac.uk/Tools/msa/clustalo), [MAFFT](https://www.ebi.ac.uk/Tools/msa/mafft) or [MUSCLE](https://www.ebi.ac.uk/Tools/msa/muscle).
> Upload the COX2 gene sequences and perform multiple sequence alignment with the parameters given below.
``` 
Parameters:
Sequence Type => DNA
Output Format => Pearson/FASTA
```
3. Perform phylogenetic tree construction using [RAxML](https://raxml-ng.vital-it.ch/) or [IQ-TREE](http://iqtree.cibiv.univie.ac.at/).
> Upload alignment file and perform phylogenetic tree construction with the following parameters.
```
Sequence Type => DNA
Substitution Model => GTR
Rate Heterogeneity => Gamma
Number of Rate Categories => 4
Ascertainment Bias Correction => None
Bootstrap Replicates => 100
```
4. Phylogenetic tree visualization and annotation using [iTOL](https://itol.embl.de/).
> Upload .support (raxml) or .treefile (iq-tree) file to iTOL.
> 
> Re-root tree by selecting the outgroup ( left click on ***mouse*** node, select ***Tree structure***, select ***Re-root the tree here*** ).
>
> ***Advance*** setting, ***Bootstraps/metadata***, ***Display*** to add Bootstrap information.
> 
> ***Export***, ***Format: PDF***, ***Export area: Screen*** and click on ***Export*** to download the tree.
