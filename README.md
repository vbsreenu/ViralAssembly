# ViralAssembly
Viral high throughput sequence  data de novo assembly pipeline.

## This pipeline has two steps:
1. Insilico read enrichment
1. Iterative de novo assembly

**1. Insilico read enrichment**
* Filter host reads with snap-aligner

Prior to this step, download host genome(s) sequence in fasta format and index it using snap index.

_snap-aligner index ref.fa HostGenome_

Indexed output will be stored in **HostGenome** directory.

Run snap-aligner and remove all the reads matching to the host genome

_hostFilter.sh file-1.fq file-2.fq HostGenome_

This will store filtered reads in **hostFiltered-1.fq** and **hostFiltered-2.fq** files.

In the next step we will do Insilco enrichment of virus of interest. For this download all the available genomes from GenBank using eutils and taxID as a search term. However, eutils download all the sequences of various lengths. We have to filter out shorter sequences from the final list. Below script download all the sequences corresponding to the taxID and removes seqeunce shorted than minimum length specified.
 
_createRef taxID minLength_

This will alos formats them for snap-aligner query and stores in **RefGenomes** directory. Now run 

**_insilicoEnrich.sh_**

This script trims the host filtered reads using trim galore and extracts reads that are matching to any reference genomes. This assumes **hostFiltered-1.fq, hostFiltered-2.fq** and **RefGenomes** are in the same directory. It saves the enriched reads in **enrichedForDenovo-1.fq** and **enrichedForDenovo-2.fq** files.

**2. Iterative de novo assembly**

Now we run de novo read assembling programs with different k-mer sizes taking subsamples of the enriched reads. 

**_iterativeDeNovo.sh_**

Above script randomly subsamples reads from enrichedForDenovo-1.fa and enrichedForDenovo-2.fa and assembles them using Spades and IDBA-UD assemblers. It iterates the assembly process for 50 times and saves the longest contigs. 
