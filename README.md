# Re-seq_analysis

Based on the known pipelines and analysis outputs of population genetics, we constructed a pipeline to treat the population sequencing data, which can be easily used by the beginners.Briefly, the clean resequencing data after quality control and trimming was mapped to the reference genome. Following the genetic variability test of all the alignments, analyzation of population phylogeny, population structure, principal component analysis, and selective elimination were parallelly conducted, as well as estimation of the genetic diversity of each population. The resulting data were visualized by the R or Python scripts.

1.Install
--
The new version will be updated and maintained in /xqteng/Re-seq_analysis, please  download the latest version，No configuration required, just unpack and use。`Due to the large volume of resequencing data, it is recommended to run on a server`
<br>Method1 For linux server
<br>`git clone https://github.com/xqteng/Re-seq_analysis.git` 
<br>`cd Re-seq_analysis`<br/>

<br>Method2 For linux server
 <br>`tar -zxvf  Re-seq_analysisXXX.tar.gz`
    <br> `cd Re-seq_analysisXXX`

2.Introduction
--
Files to prepare before using this software include clean data, reference genome, sampling information file (a text file with a column of sampling IDs)
<br>`xample：xxx_R1.fq.gz/xxx_R2.fq.gz,xxx.fa(xxx.fna),xxx.sampleID(dpending on the number of your groups)`
```
[server]$  cat YZ.sampleID
cro_001
cro_002
cro_003
cro_004
cro_005
cro_007
cro_008
cro_009
cro_010
cro_011
cro_012
```
3.Usage
--
```
usage: select parameters:***.py [-h] [-STAGE STAGE] [-J JOB] [-T THREADNUM] [-SP SP] [-fasta-file-path FASTA] [-N N1] [-s S1] [-window-pi WP1] [-window-pi-step WPS1]
                                [-MF MF] [-MM MM] [-CHR CHR] [-K K]

optional arguments:
  -h, --help            show this help message and exit
  -STAGE STAGE, --stage STAGE
                        choose step to run,-STAGE 1 is mapping+snp calling+vcf generate,-STAGE 2 is vcf filter,-STAGE 3 is pca+admixture+Phylogenetic analyse to
                        divide populations,-STAGE 4 is pca+admixture+Phylogenetic analyse+LDdecay+snp denisity+Genetic diversity datas+selective sweep analysis etc
  -J JOB, --job JOB     the number of jobs to submit,default=10
  -T THREADNUM, --threadnum THREADNUM
                        threads ,default=4
  -SP SP, --sp SP
  -fasta-file-path FASTA, --fasta FASTA
  -N N1, --n1 N1        times of bootstraps,default=10
  -s S1, --s1 S1        the window size of snp density,default=10w
  -M M,--M M            the max value of legend of SNP_density plot,default=500
  -wp WP1, --wp1 WP1
                        the window size of Pi/Fst/xp-clr,default=5000
  -wps WPS1, --wps1 WPS1
                        the window step of Pi/Fst/xp-clr,default=2000
  -MF MF, --mf MF       the Minor Allele Frequency to filter snp,default=0.05
  -MM MM, --mm MM       the Max-missing rate,default=0.2
  -CHR CHR, --chr CHR   Chromosomes splited with "," e.g -CHR 1,2,3,4,5
  -K K, --k K           your belief of the number of ancestral populations
```
4.Example
---
(1)-STAGE 1 is mapping+snp calling+vcf generate,You should prepare the reference genome and clean data in advance in the same catalogue
<br>`result documents:mapping(.sam),snp calling(.bam,.markduplicate,.gvcf),vcf generate(all_raw.vcf)`
```
python Re-seq_analysis --STAGE 1
```
<br>(2)-STAGE 2 is vcf filter,You can run it directly from the STAGE 1 results directory or bring your own unfiltered VCF file
<br>`result documents:all_raw.vcf-->all_snp,vcf` 
<br>`*Attention：<1>Some VCF files have irregular chromosome names in the first column, please change them manually to standard numbers such as 1, 2. <2>Please keep only chromosomal SNPs manually for VCF files.`
```
python Re-seq_analysis --STAGE 2 -MM 0.5 -MF 0.02
```

<br>-STAGE 3 is pca+admixture+Phylogenetic analyse to divide populations which You're not quite sure about your group sub-groups.
<br>`result documents:pca(.eigenvec,.eigenval),admixture(plink.P,plink.Q),Phylogenetic analyse(.bestTree.nwk)`
```
python Re-seq_analysis --STAGE 3 -N 100 -K 1,2,3,4,5,6,7 
```
<br>-STAGE 4 is pca+admixture+Phylogenetic analyse+LDdecay+snp denisity+Genetic diversity datas+selective sweep analysis etc
<br>`result documents:pca(.eigenvec,.eigenval),admixture(plink.P,plink.Q),Phylogenetic analyse(.bestTree.nwk),LDdecay(stat.gz),snp denisity(.denisity.png),Genetic diversity datas(.hwe,.het,.pic),selective sweep analysis(.pi,.fst,.fst_pi,.xpclr)`
```
python Re-seq_analysis --STAGE 4 -s 100000 -M 500 -N 100 -K 1,2,3,4,5,6,7 --wp 50000 -wps 2000 -CHR 01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
```


