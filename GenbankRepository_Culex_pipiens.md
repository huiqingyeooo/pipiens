# Pipeline for pipiens popgen
## 1. Find Culex pipiens complex whole genome reads in Genbank repository

1. Search for Culex pipiens in genbank taxonomy (https://www.ncbi.nlm.nih.gov/datasets/taxonomy/7175/)
2. Go to BioProject and click on the number of projects (#87)
3. Look through project titles and select relevant projects (e.g., individually sequenced Culex samples, not ChIP-seq, transcriptomics, ddRADSeq etc)
4. Go to SRA Experiments and click on number under 'Number of Links'
5. Click on one of the samples, and the click on 'All runs' under the 'Study' section
6. This will bring you to an SRA run selector with all the metadata available under the BioProject
7. More information about the samples is available if you download 'Metadata' (e.g., locality, latlong, collection date and type)
8. Download SRA and convert to fastq.gz files (sratoolkit_TEMPLATE.slurm)

## 2. Trim reads
- Trimming reads using fastp. As there are samples from multiple sources, it was easier to customise each fastp script according to their source. (E.g., fastp_lane1_TEMPLATE.slurm, fastp_ags_TEMPLATE.slurm, fastp_sra_TEMPLATE.slurm)

## 3. Align reads
- Read alignment was carried out in batches (alphabetical order)
- bowtie_pipiens_TEMPLATE.slurm

## 4. Mark duplicates and indel realignment
### Following gatk recommendations
- https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery
- https://github.com/broadinstitute/gatk-docs/blob/master/gatk3-tutorials/(howto)_Perform_local_realignment_around_indels.md

### a. Mark or replace read groups
- https://gatk.broadinstitute.org/hc/en-us/articles/360035890671-Read-groups
RGID: must be unique (flowcell name + lane number)
RGPU: flowcell.lane.sampleBarcode
RGSM: sample name (GATK will treat all read groups from the same sample as one)
RGPL: sequencing platform
RGLB: DNA prep library identifier (in case the same DNA library sequenced on multiple lanes, or vice versa)

### b. Mark sequence duplicates with picard
Note that this doesn't remove duplicates unless --REMOVE_DUPLICATES or --REMOVE_SEQUENCING_DUPLICATES is specified
MAX_FILE_HANDLES_FOR_READ_ENDS_MAP : set this to slightly under system limit. Check with command ulimit -n
NOTE: try without MAX_RECORDS_IN_RAM=300000 if file is too big. Usually 100000
To check memory of RAM: grep MemTotal /proc/meminfo
If not enough memory, add in code java -Xms12G -Xmx14G -jar /home/kyle/miniconda3/envs/ame/share/picard-2.21.4-0/picard.jar MarkDuplicates

### c. Build bam index for RealignerTargetCreator to run
Produces a BAM index file (.bai) for each sample
Note: file names for bam and bai have to be the same for each sample

### d. Run RealignerTargetCreator
- Only gatk3 has RealignerTargetCreator and IndelRealigner available. Deprecated in gatk4
- Adds indel sites in the alignment CIGAR strings to targets
- Considers presence of mismatches and soft clips and adds regions above a threshold to target intervals
Output: produces a file with chromosomes and basepair start and end points of the indels
NOTE: use low number of threads and increase ulimit if error is encountered
- if code does not work, try running ulimit -n 4096 first

### e. Run IndelRealigner
Performs local realignment based on coordinate-sorted and indexed BAM, and target intervals files

### f. Remove intermediate files, clean up folder

### g. Check quality of alignment (aligment stats) using qualimap
- To generate summary statistics for aligned bam files
- MAPQ score of realigned reads should increase after gatk indel realignment
- ip: collect statistics on overlapping paired reads
- outfile: flag only accepts filenames
- outdir: flag accepts filepaths







### Personal notes on BioProjects of interest:
#### Sequencing of the mosquitoes Culex lineages Tunis and Harash
10 isofemales from each population pooled and sequenced on both Illumina and Nanopore platforms
https://academic.oup.com/genetics/advance-article/doi/10.1093/genetics/iyag135/8691036?login=true
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP678574&o=acc_s%3Aa

#### Wolbachia populations in Culex pipiens individuals from Southern France
Trouche et al 2024
https://academic.oup.com/ismecommun/article/4/1/ycae078/7691189?login=true#468312085
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=ERP141313&o=acc_s%3Aa



