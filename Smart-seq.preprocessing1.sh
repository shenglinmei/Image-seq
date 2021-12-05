#! /bin/bash 

SAMPLE=$1

## Directory for input fastq files
INPUTDIR=/home/meisl/tenXdata/Christa_smart_seq2/data.rc.fas.harvard.edu/ngsdata/191114_NB502063_0382_AHW53WAFXY/Leukemia_proliferation_non-proliferation/
OUTPUT=${SAMPLE}.genome
FQ1=${INPUTDIR}/${SAMPLE}_R1_001.fastq.gz
FQ2=${INPUTDIR}/${SAMPLE}_R2_001.fastq.gz

## Directory for hisat2 reference index
REF=/home/meisl/tenXdata/Reference/mm10/ss2_hisat2_rsem/hisat2_index_gencode_grcm38_vM17_genome_snp_tran/genome_snp_trans

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
      --secondary \
      --seed 12345 \
      -p 4 -S ${OUTPUT}.sam

##samtools view -bS  "${OUTPUT}.sam" > "${OUTPUT}.bam"
samtools sort -@ 4 -O bam -o ${OUTPUT}.bam ${OUTPUT}.sam
rm "${OUTPUT}.sam"

