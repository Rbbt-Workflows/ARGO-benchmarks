Minified real tumor/normal benchmarks
=====================================

Introduction
------------

These benchmarks are derived from Texas sample TCRBOA7 of the [Baylor college
open access pilot](https://www.nature.com/articles/sdata201610). The are
minified versions that can be used for technical benchmarking. Their usefulness
for scientific benchmarking may be limited right now, since the regions
selected are not designed to capture any particular feature of interest.

Design
------

The WGS reads for the tumor and the normal samples where aligned to the hg38
reference. For each benchmark we defined a BED file with regions of interest,
which is used to fish-out all the reads that overlap those regions along with
their corresponding pairs. The pairs need not fall inside these regions. This
process has two steps, first selecting the reads names that overlap the regions
using samtools, and then using GATK's FilterSamReads with that list. This
ensures that the reads pairs are respected.

Files provided
--------------

Each benchmark includes the following files

* *FASTQ*: the FASTQ files for the normal and tumor samples, each set in
  a directory
* *CRAM*: the reads on their original alignments, in CRAM format, using the
  original hg38 reference
* *CRAM-mini*: the reads re-aligned to the mini-reference, in CRAM format
* *mini-reference*: a minified version of the reference including only the
  regions selected
* *regions*: contains the BED file with the regions used to select the reads

Note that the mini-reference is *not* the one used to produce the CRAM files
provided. It's is intended to be used in alignment and variant calling
pipelines to speed-up the process. It also contains minified versions of the
typical population resources that re used in these pipelines. It's important to
point out that when slicing portions of the reference and mushing them into
a mini-reference the locations of genomic elements, such as SNPs may also need
to be adjusted.

Types of benchmarks
-------------------

We have two types of benchmarks: cropped and sliced. The cropped alternative
only takes the start of chromosomes. The beginning of chromosomes include
telomeric regions and such that are not well characterized, however they have
the benefit that the genomic elements that fall inside these regions do not
need to have their positions adjusted on the mini-reference. The sliced
alternative takes our a set regions spreads across the chromosomes, allowing to
target arbitrary regions across them. The mini-reference for the sliced
alternative is done by mushing together these regions and requires us to adjust
the positions of genomic elements like SNPs.

Here we provide a selection of benchmarks with different sizes and types, which
might be suitable in different scenarios.

Name              | Size
-                 | -
minimal           | 14M
minimal_multi_chr | 27M
tiny_crop         | 3.8G
tiny_slice        | 5.8M
small_slice       | 52M
small_crop        | 6.2G
