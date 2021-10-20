#/bin/bash

gatk CreateSequenceDictionary -R hg38.fa.gz; samtools faidx hg38.fa.gz ; bwa index hg38.fa.gz; zcat hg38.fa.gz > hg38.fa; for f in *.gz.*; do ln -s $f ${f/.gz/}; done; cd known_sites/; for f in *.gz; do gatk IndexFeatureFile -I $f; done
