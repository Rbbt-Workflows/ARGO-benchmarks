#!/bin/bash

for t in normal tumor; do
    drbbt workflow task HTS BAM -r $(realpath mini-reference/hg38.fa.gz) --fastq1 $(realpath FASTQ/${t}/${t}_read1.fq.gz) --fastq2 $(realpath FASTQ/${t}/${t}_read2.fq.gz) --log 0 -cl -O CRAM-mini/${t}.bam -ck HTS_light
    samtools view -C -T mini-reference/hg38.fa.gz -o CRAM-mini/${t}.cram CRAM-mini/${t}.bam
    samtools index  CRAM-mini/${t}.cram
    rm CRAM-mini/${t}.bam
done
