#! /bin/bash 

fin=$1


REF=/home/meisl/tenXdata/Reference/mm10/ss2_hisat2_rsem/rsem_index_gencode_grcm38_vM17/rsem_trans_index
INPUT_DIR=/home/meisl/tenXdata/Christa_smart_seq2/data.rc.fas.harvard.edu/ngsdata/191114_NB502063_0382_AHW53WAFXY/Leukemia_proliferation_non-proliferation/tmp/
SAMPLE=$fin

/home/meisl/bin//usr/local/bin/rsem-calculate-expression -p 4 \
      --time --seed 555 \
      --calc-pme \
      --single-cell-prior \
      --paired-end \
      --bam \
      ${INPUT_DIR}/${SAMPLE}.trans.bam \
      ${REF} \
      ${SAMPLE}


gtf=/home/meisl/tenXdata/Reference/mm10/ss2_hisat2_rsem/gencode.vM17.primary_assembly.annotation.gtf

~/bin/subread-2.0.0-source/bin/featureCounts -T 5 -p -t exon -g gene_name  -a $gtf -o  ${SAMPLE}  ${INPUT_DIR}/${SAMPLE}.genome.bam


