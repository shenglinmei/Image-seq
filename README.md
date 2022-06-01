# Image-seq

Custom code that was used in this study can be found on github at https://github.com/shenglinmei/Image-seq


## Software dependencies and operating systems 

- This protocol assumes users have a Unix-like operating system (i.e., Linux or MacOS X), with a bash shell or similar.
- Cellranger (version 3.0.2) https://support.10xgenomics.com/single-cell-gene-expression/software/overview/welcome
- Conos (version 1.4.6 ) https://github.com/kharchenkolab/conos
- hisat (version 2.2.0 ) http://daehwankimlab.github.io/hisat2/
- featureCounts (v1.6.4) https://www.rdocumentation.org/packages/Rsubread/versions/1.22.2/topics/featureCounts
- Seurat (version 4.0 ) https://satijalab.org/seurat/


## Installation 
Please follows instruction above to install depedent softwares.  

## Demo data for Smart-seq processing 

OUTPUT=${SAMPLE}.genome
FQ1=${INPUTDIR}/${SAMPLE}_R1_001.fastq.gz
FQ2=${INPUTDIR}/${SAMPLE}_R2_001.fastq.gz

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
      -p 4 -S ${OUTPUT}.bam

featureCounts -T 5 -p -t exon -g gene_name  -a $gtf -o  ${SAMPLE}  ${INPUT_DIR}/${SAMPLE}.genome.bam


