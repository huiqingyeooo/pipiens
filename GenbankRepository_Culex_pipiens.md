# Pipeline for pipiens popgen
## Finding Culex pipiens complex whole genome reads in Genbank repository

1. Search for Culex pipiens in genbank taxonomy (https://www.ncbi.nlm.nih.gov/datasets/taxonomy/7175/)
2. Go to BioProject and click on the number of projects (#87)
3. Look through project titles and select relevant projects (e.g., individually sequenced Culex samples, not ChIP-seq, transcriptomics, ddRADSeq etc)
4. Go to SRA Experiments and click on number under 'Number of Links'
5. Click on one of the samples, and the click on 'All runs' under the 'Study' section
6. This will bring you to an SRA run selector with all the metadata available under the BioProject
7. More information about the samples is available if you download 'Metadata' (e.g., locality, latlong, collection date and type)
8. Download SRA and convert to fastq.gz files (sratoolkit_TEMPLATE.slurm)

## Trim reads
- Trimming reads using fastp. As there are samples from multiple sources, it was easier to customise each fastp script according to their source. (E.g., fastp_lane1_TEMPLATE.slurm, fastp_ags_TEMPLATE.slurm, fastp_sra_TEMPLATE.slurm)

## Align reads
- Read alignment was carried out in batches (alphabetical order)



### Notes on BioProjects of interest:

#### Sequencing of the mosquitoes Culex lineages Tunis and Harash
10 isofemales from each population pooled and sequenced on both Illumina and Nanopore platforms
https://academic.oup.com/genetics/advance-article/doi/10.1093/genetics/iyag135/8691036?login=true
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP678574&o=acc_s%3Aa

#### Wolbachia populations in Culex pipiens individuals from Southern France
Trouche et al 2024
https://academic.oup.com/ismecommun/article/4/1/ycae078/7691189?login=true#468312085
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=ERP141313&o=acc_s%3Aa



