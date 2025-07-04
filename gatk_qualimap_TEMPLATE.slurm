#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=20:00:00
#SBATCH --mem=100G

####### Set environment variables ###############
module load lib/zlib/1.2.11
module load gcc/10.2.0
PATH=/work/soghigian_lab/apps/samtools-1.15/bin:$PATH
PATH=/work/soghigian_lab/apps/qualimap_v2.2.1/:$PATH

# activate conda for picard and gatk3
source ~/software/init-conda-sl
conda activate /work/soghigian_lab/apps/conda/envs/picard

# define variables
projDir=/work/soghigian_lab/huiqing.yeo/pipiens/2_indelRealigned
refGenome=/work/soghigian_lab/huiqing.yeo/pipiens/refGenome/pipiens/Cpip29_nodebris_gapfill.fasta
mappedReads1=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads_pipiens_lane1
mappedReads2=/scratch/33462325/1_alignedReads_pipiens_lane2
#outgroups=/work/soghigian_lab/huiqing.yeo/pipiens/0_alignedReads_pipiens_outgroups

# loop code
cd ${projDir}
#for file in $(ls ${outgroups}/*_sorted.bam);

#for file in $(ls ${mappedReads1}/*_sorted.bam);
#do
#taxa=$(basename $file _sorted.bam)
#echo ${taxa}
#sed "s/TEMPLATE/${taxa}/g" gatk_qualimap_TEMPLATE.slurm > gatk_qualimap_${taxa}.slurm
#sbatch gatk_qualimap_${taxa}.slurm
#sleep 1
#done

echo "starting run at: `date`"

####### Script ##################################
# Following gatk recommendations
# https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery
# https://github.com/broadinstitute/gatk-docs/blob/master/gatk3-tutorials/(howto)_Perform_local_realignment_around_indels.md

##2.0 Mark or replace read groups
# https://gatk.broadinstitute.org/hc/en-us/articles/360035890671-Read-groups
# RGID: must be unique (flowcell name + lane number)
# RGPU: flowcell.lane.sampleBarcode
# RGSM: sample name (GATK will treat all read groups from the same sample as one)
# RGPL: sequencing platform
# RGLB: DNA prep library identifier (in case the same DNA library sequenced on multiple lanes, or vice versa)

picard AddOrReplaceReadGroups I=${mappedReads1}/TEMPLATE_sorted.bam \
O=${projDir}/TEMPLATE_lane1_RG.bam \
RGID=lane1 RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=lane1.TEMPLATE 

picard AddOrReplaceReadGroups I=${mappedReads2}/TEMPLATE_sorted.bam \
O=${projDir}/TEMPLATE_lane2_RG.bam \
RGID=lane2 RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=lane2.TEMPLATE

#picard AddOrReplaceReadGroups I=${outgroups}/TEMPLATE_sorted.bam \
#O=${projDir}/1_indelRealigned/TEMPLATE_RG.bam \
#RGID=outgroup.TEMPLATE RGSM=TEMPLATE RGLB=TEMPLATE RGPL=illumina RGPU=outgroup.TEMPLATE

##2.1 Mark sequence duplicates with picard
# Note that this doesn't remove duplicates unless --REMOVE_DUPLICATES or --REMOVE_SEQUENCING_DUPLICATES is specified
# MAX_FILE_HANDLES_FOR_READ_ENDS_MAP : set this to slightly under system limit. Check with command ulimit -n
# NOTE: try without MAX_RECORDS_IN_RAM=300000 if file is too big. Usually 100000
# To check memory of RAM: grep MemTotal /proc/meminfo
# If not enough memory, add in code java -Xms12G -Xmx14G -jar /home/kyle/miniconda3/envs/ame/share/picard-2.21.4-0/picard.jar MarkDuplicates

#picard MarkDuplicates I=TEMPLATE_RG.bam \
#O=TEMPLATE_markDups.bam M=TEMPLATE_output.txt \
#TAGGING_POLICY=All MAX_RECORDS_IN_RAM=300000 \
#MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000

picard MarkDuplicates I=TEMPLATE_lane1_RG.bam \
I=TEMPLATE_lane2_RG.bam \
O=TEMPLATE_markDups.bam M=TEMPLATE_output.txt \
TAGGING_POLICY=All MAX_RECORDS_IN_RAM=300000 \
MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000

##2.2 Build bam for RealignerTargetCreator to run
# Produces a BAM index file (.bai) for each sample
# Note: file names for bam and bai have to be the same for each sample

picard BuildBamIndex I=TEMPLATE_markDups.bam O=TEMPLATE_markDups.bai 

##2.3 Run RealignerTargetCreator
# Only gatk3 has RealignerTargetCreator and IndelRealigner available. Deprecated in gatk4
# adds indel sites in the alignment CIGAR strings to targets
# considers presence of mismatches and soft clips and adds regions above a threshold to target intervals
# Output: produces a file with chromosomes and basepair start and end points of the indels
# NOTE: use low number of threads and increase ulimit if error is encountered
# if code does not work, try running ulimit -n 4096 first

GenomeAnalysisTK -T RealignerTargetCreator -R ${refGenome} -nt 8 -I TEMPLATE_markDups.bam -o TEMPLATE.intervals

##2.4 Run IndelRealigner
# Performs local realignment based on coordinate-sorted and indexed BAM, and target intervals files

GenomeAnalysisTK -T IndelRealigner -R ${refGenome} -targetIntervals TEMPLATE.intervals \
-I TEMPLATE_markDups.bam -o TEMPLATE_realigned.bam 

##2.5 Remove intermediate files
rm TEMPLATE_lane1_RG.bam
rm TEMPLATE_lane2_RG.bam
#rm TEMPLATE_RG.bam
rm TEMPLATE_markDups.bam
rm TEMPLATE_markDups.bai
rm TEMPLATE_realigned.bai
rm TEMPLATE.intervals

##2.6 Check quality of alignment (aligment stats) using qualimap
# To generate summary statistics for aligned bam files
# MAPQ score of realigned reads should increase after gatk indel realignment
# Alternative program to view alignments and check quality: IGV (https://github.com/broadinstitute/gatk-docs/blob/master/gatk3-tutorials/(howto)_Visualize_an_alignment_with_IGV.md)
# ip: collect statistics on overlapping paired reads
# outfile: flag only accepts filenames
# outdir: flag accepts filepaths

mkdir qualimap
qualimap bamqc -bam TEMPLATE_realigned.bam -nt 8 -ip --java-mem-size=10G -outfile TEMPLATE_realigned.pdf --outdir ./qualimap/TEMPLATE_realigned

echo "Job finised with exit code $? at: `date`"
