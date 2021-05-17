# SARS-CoV-2 RdRp Molecular Docking
## Installation
1. AutoDock Vina
```
$ conda install -c bioconda autodock-vina
```
2. PyMOL
```
$ sudo apt-get install -y pymol
```
3. AutoDock Tools

Check system type
```
$ uname -m
```
Download appropriate version of MGLTools from https://ccsb.scripps.edu/mgltools/downloads/
```
$ chmod +x mgltools_Linux-x86_64_1.5.7_install
$ ./mgltools_Linux-x86_64_1.5.7_install
```
Browse and choose the location to install

## Download Receptor and Ligand

Receptor: 6M71 (SARS-Cov-2 RNA-dependent RNA polymerase) from PDB in .pdb format

Ligand: GS-441524 (adenosine nucleotide analog i.e. remdesivir) from pubchem in 3D SDF format

Convert SDF to PDB from https://cactus.nci.nih.gov/translate/

## Preparation

### Preparation of Receptor and Ligand using PyMOL
Run PyMOL
```
$ pymol
```
Open protein/ligand in PyMOL
```
>File >Open >Select pdb file
```
Delete unnecessary components (chain/atoms) if any

Remove Water molecules if any
```
>Protein(6M71) >A(Action:) >remove water
```
Save protein/ligand in PDB format
```
>File >Save Molecule >OK >Save
```

### Preparation of Receptor and Ligand using AutoDock Tools
Run AutoDock Tools
```
$ cd MGLTools-1.5.7/bin/
$ ./adt
```
Open ligand in AutoDock Tools
```
>Ligand >Input >Open 
```
Choose rotatable bonds
```
>Ligand >Torsion Tree >Detect Root
```
Saving ligand in pdbqt format
```
>Ligand >Output >Save as PDBQT
```
Open receptor in AutoDock Tools
```
>Grid >Macromolecule >Open
```
It automatically asks to save receptor in PDBQT format

Add polar hydrogens
```
>Edit >Hydrogens >Add >Polar only
```
Saving receptor in pdbqt format
```
>Grid >Macromolecule >Choose >Select >Save
OR
>File >Save >Write PDBQT
```

Get coordinates for docking
```
>Grid >Grid Box
```
Adjust and write all the coordinates and dimensions

## Perform Docking
```
$ vina --receptor Receptor.pdbqt --ligand Ligand.pdbqt --center_x 215.5 --center_y 230.1 --center_z 260.0 --size_x 126 --size_y 126 --size_z 126
```
## Result
Ligand_out.pdbqt

## Result Visualization
Open Receptor (6M71) PDB file in PyMOL

Open Ligand_out.pdbqt file in same PyMOL window

>Various sites where ligand docked can be seen by using Left/Right arrow present at right bottom of the pymol window

>The binding energy for various sites can be seen in terminal where vina was run
