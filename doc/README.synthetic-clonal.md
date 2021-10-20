Synthetic-clonal benchmarks
===========================

Introduction
------------

These benchmarks are produced by a similar process as the simple synthetic
ones, but wrapping several of these simulations into one. The basic idea is
that to simulate clonality we simulate each clone separately and then select
reads at random based on a specified configuration of cellular fractions. The
clone's genomic background is specified by an _evolution_ file. Each clone
inherits its genomic background from its parent clone and adding its own set of
somatic alterations. All clones also share the same set of germline variations.
In addition to genomic point mutations, these benchmarks also support
_structural variations_ (SVs), to simulate these we edit the chromosomes in the
reference file that is passed to then simulation software. Furthermore, ploidy
is made explicit in the process by duplicating each of the chromosome copies in
the reference, and leaving them to evolve independently.

This new approach requires plenty of internal bookkeeping to make sure that
mutations are introduced in the right place after all the edits. Mutations are
duplicated, lost or present in LOH by the effects of SVs. The evolution file
used to describe the genomic background of each clone is specified in terms of
the original hg38 reference sequence so that it can be compared with what comes
out of analyses pipelines. For more precise situations, it is possible in the
evolution file to specify the chromosome copy that harbor the mutations.

Files provided
--------------

Due to the complex process involved in generating these benchmarks, it is not
easy to provide a golden_CRAM with the real location where the reads are
simulated from the mini-reference, as well as the actual mini-reference. These
are in general different for each clone. Due to this difficulties we only
include the following files

* *FASTQ*: Fastq files for the (pair-end) reads of the tumor normal samples,
  each on their own subfolder
* *evolution.yaml*: Evolution file used to define the genomic composition of
  each clone and the cellular fraction in the simlated sample
