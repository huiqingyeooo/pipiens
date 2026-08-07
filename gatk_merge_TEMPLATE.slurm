#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=48:00:00
#SBATCH --mem=50G

####### Set environment variables ###############
module load lib/zlib/1.2.11
module load gcc/10.2.0
module load java/openjdk-11.0.2
PATH=/work/soghigian_lab/apps/qualimap_v2.3/:$PATH
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH

# activate conda for picard and gatk3
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/picard

# define variables
scripts=/work/soghigian_lab/huiqing.yeo/pipiens/scripts/pipiens
projDir=/work/soghigian_lab/huiqing.yeo/pipiens/2_indelRealigned
refGenome=/work/soghigian_lab/huiqing.yeo/pipiens/refGenome/pipiens_new/Cpip_nodebris_gapclosed_Apr4
#mappedReads1=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/canada/lane1
#mappedReads2=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/canada/lane2

# scratch dir
scratchDir=/scratch/45624817
projDir=${scratchDir}/2_indelRealigned
mappedReads=${scratchDir}/1_alignedReads

# loop code
cd ${projDir}
#for file in $(ls ${mappedReads1}/*_q20_sorted.bam);
#do
#taxa=$(basename $file _q20_sorted.bam)
#echo ${taxa}
#cd ${scripts}
#sed "s/TEMPLATE/${taxa}/g" gatk_merge_TEMPLATE.slurm > ${projDir}/gatk_merge_${taxa}.slurm
#sbatch --output ${projDir}/slurm-%j.out ${projDir}/gatk_merge_${taxa}.slurm
#sleep 1
#done

echo "starting run at: `date`"

#########################################
#### Script 
#########################################
### Create fasta index file for reference genome. Only need to do this once
#samtools faidx ${refGenome}.fasta
#picard CreateSequenceDictionary R=${refGenome}.fasta O=${refGenome}.dict

### a. Mark or replace read groups
echo "Marking or replacing read groups for sample_TEMPLATE"
#picard AddOrReplaceReadGroups I=${mappedReads1}/TEMPLATE_q20_sorted.bam O=${projDir}/TEMPLATE_lane1_RG.bam \
#RGID=lane1 RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=lane1.TEMPLATE 

#picard AddOrReplaceReadGroups I=${mappedReads2}/TEMPLATE_q20_sorted.bam O=${projDir}/TEMPLATE_lane2_RG.bam \
#RGID=lane2 RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=lane2.TEMPLATE

#picard AddOrReplaceReadGroups I=${mappedReads}/TEMPLATE_q20_sorted.bam O=${projDir}/1_indelRealigned/TEMPLATE_RG.bam \
#RGID=outgroup.TEMPLATE RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=outgroup.TEMPLATE

### b. Mark sequence duplicates with picard
echo "Marking duplicates for sample_TEMPLATE"

#picard MarkDuplicates \
#merge lane1 and lane2 bam files
#I=TEMPLATE_lane1_RG.bam I=TEMPLATE_lane2_RG.bam \ 
#O=TEMPLATE_markDups.bam M=./metrics/TEMPLATE_markDup.txt \
#TAGGING_POLICY=All MAX_RECORDS_IN_RAM=300000 MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
#VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true REMOVE_DUPLICATES=false

#picard MarkDuplicates I=TEMPLATE_RG.bam \
#O=TEMPLATE_markDups.bam M=TEMPLATE_output.txt \
#TAGGING_POLICY=All MAX_RECORDS_IN_RAM=300000 \
#MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
#VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true REMOVE_DUPLICATES=false

### c. Build bam index for RealignerTargetCreator to run
echo "Building bam index for sample_TEMPLATE"
#picard BuildBamIndex I=TEMPLATE_markDups.bam O=TEMPLATE_markDups.bai 

### d. Run RealignerTargetCreator
echo "Running RealignerTargetCreator for sample_TEMPLATE"
GenomeAnalysisTK -T RealignerTargetCreator -R ${refGenome}.fasta -nt 8 -I TEMPLATE_markDups.bam -o TEMPLATE.intervals

### e. Run IndelRealigner
echo "Running IndelRealigner for sample_TEMPLATE" 
GenomeAnalysisTK -T IndelRealigner -R ${refGenome}.fasta -targetIntervals TEMPLATE.intervals -I TEMPLATE_markDups.bam -o TEMPLATE_realigned.bam 

### f. Remove intermediate files, clean up folder
echo "Removing intermediate files for sample_TEMPLATE" 
#rm TEMPLATE_lane1_RG.bam
#rm TEMPLATE_lane2_RG.bam
rm TEMPLATE_RG.bam
#rm TEMPLATE_markDups.bam
#rm TEMPLATE_markDups.bai
#rm TEMPLATE_realigned.bai
#rm TEMPLATE.intervals

### g. Check quality of alignment (aligment stats) using qualimap
echo "Running qualimap for sample_TEMPLATE" 
mkdir qualimap
qualimap bamqc -bam TEMPLATE_realigned.bam -nt 4 -ip --java-mem-size=10G -outfile TEMPLATE_realigned.pdf --outdir ./qualimap/TEMPLATE_realigned

echo "Job finised with exit code $? at: `date`"