Synthetic benchmarks
====================

Introduction
------------

These benchmarks are generated with the [NEAT GenReads
tool](https://github.com/zstephens/neat-genreads). They simulate a pair of
tumor/normal samples. Both samples share a set of germline mutations, and the
tumor sample in addition harbors an additional set of somatic mutations.
Knowing the mutations that are introduced allows for both assess the precision
and recall of different variant calling pipelines. Due to the nature of the
simulation software, all mutations, germline and somatic, are introduced in
heterozygous allele frequency.

Design
------

The set of germline SNPs are introduced randomly from 1000 Genomes following
the European population frequencies. Somatic mutations are taken from
a particular PCAWG cohort (Bladder-TCC) as follows. A fixed number of mutations
(20,000,000) is selected from the pool of mutations of all the cohorts
patients. Each chromosome is cropped at a position at the beginning of each
chromosome that ensures at least a minimum number of somatic mutations are
found featured (100 for the basic and 10 for the minimal benchmarks). Some
padding is added to these ranges to ensure reads are sufficiently covered over
these minimum set of somatic mutations.

A minified version of the reference is produced by cropping each chromosome at
the locations defined as described above. This minified version is used by the
simulation software, along with the germline and somatic variant lists to
simulate reads for the tumor and normal pairs (at depths 60X and 30X
respectively).

Since the mini-reference is of the 'cropped' type, the variants called by
a variant calling software using either the original hg38 or the mini-reference
will have the same coordinates and can be directly compared with the ground
truth. For the evaluation a tool such as [RTG
vcfeval](https://github.com/RealTimeGenomics/rtg-tools) is recommended.

Files provided
--------------

The following files are included:

* *FASTQ*: Fastq files for the (pair-end) reads of the tumor normal samples,
  each on their own subfolder
* *golden_CRAM*: CRAM file with the reads aligned to their _real_ locations *on
  the mini-reference*
* *CRAM*: CRAM file with the reads aligned to the *original hg38 reference*
  using an alignment pipeline
* *mini-reference*: A minified version of the hg38 reference that can be used
  for accelerating the workflows 
* *mini-reference/known_sites*: Minified version of the hg38 reference
  population resources used typically in variant calling workflows
* *truth*: Underlying biological truth of the sample or definitions files used
  to generated

Please note that the CRAM files under the golden_CRAM and them CRAM directories
are aligned using different references and the CRAM files are built using them.
This will be very important when using them.
