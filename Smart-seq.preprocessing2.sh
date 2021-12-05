#!/bin/bash

SAMPLE=$1


## Directory for input fastq files
INPUTDIR=/home/meisl/tenXdata/Christa_smart_seq2/data.rc.fas.harvard.edu/ngsdata/191114_NB502063_0382_AHW53WAFXY/Leukemia_proliferation_non-proliferation/
#SAMPLE=20190925_1_2_S1
OUTPUT=${SAMPLE}.trans
FQ1=${INPUTDIR}/${SAMPLE}_R1_001.fastq.gz
FQ2=${INPUTDIR}/${SAMPLE}_R2_001.fastq.gz

## Directory for hisat2 reference index
REF=/home/meisl/tenXdata/Reference/mm10/ss2_hisat2_rsem/hisat2_index_gencode_grcm38_vM17_transcriptome/tran







## Hisat2 mapping 
hisat2 -t \
      -x ${REF} \
      -1 ${FQ1} \
      -2 ${FQ2} \
      --rg-id=${SAMPLE} --rg SM:${SAMPLE} --rg LB:${SAMPLE} \
      --rg PL:ILLUMINA --rg PU:${SAMPLE} \
      --new-summary --summary-file ${OUTPUT}.log \
      --met-file ${OUTPUT}.hisat2.met.txt --met 5 \
      -k 10 \
      --mp 1,1 \
      --np 1 \
      --score-min L,0,-0.1 \
      --secondary \
      --no-mixed \
      --no-softclip \
      --no-discordant \
      --rdg 99999999,99999999 \
      --rfg 99999999,99999999 \
      --no-spliced-alignment \
      --seed 12345 \
      -p 4 -S ${OUTPUT}.sam 


samtools view -bS  "${OUTPUT}.sam" > "${OUTPUT}.bam"

