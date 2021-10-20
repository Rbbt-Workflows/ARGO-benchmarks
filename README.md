Open Benchmarks for OMICs analyses
=============================

Preface
-------

These benchmarks have been prepared for the ICGC-ARGO project, specifically as
part of the "variant calling working group". We aim to simplify testing tools
and infrastructure for OMICs by providing datasets that are open to share and
convenient to use. For us, "technical benchmarking" attempts only to see if tools
are executed without fault while "scientific benchmarking" attempts also to
evaluate the quality of their results.

Types of benchmarks
-------------------

We have two mayor types of benchmark samples: synthetic and real. _Synthetic_
benchmark samples are generated in a control way based on some definition of
the sample's biology. This definition serves as "ground truth", so, in addition
to technical benchmarking it can be used for scientific benchmarking. _Real_
benchmarks are usually hard to come about, as they are typically very
privacy-sensitive. Also, they "ground truth" is generally not available, so
"scientific benchmarking" is not possible, or it must resort to using indirect
assessments like inter-tool agreements or, in the best scenario, the use of
orthogonal high-resolution experiments.

A third type of benchmarks are called *Synthetic-clonal* and are generated
following a much more involved process that simulates clonality and structural
variants 

Files provided
--------------

The benchmarks provided here are currently intended primarily to test alignment
and variant calling workflows. Each benchmark may contain a series of folders:

* *FASTQ*: Fastq files for the (pair-end) reads of the tumor normal samples, each on their own subfolder 
* *CRAM*: CRAM file with the aligned reads for the tumor and normal samples
* *mini-reference*: A minified version of the hg38 reference that can be used for accelerating the workflows
* *mini-reference/known_sites*: Minified version of the hg38 reference population resources used typically in variant calling workflows
* *truth*: Underlying biological truth of the sample or definitions files used to generated

More details are found in the folder that contains benchmarks for each type. To
help use in workflows, files of different kinds (CRAM, FASTA, VCF) are pre-index.
