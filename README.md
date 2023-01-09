# Re-seq_analysis
Based on the known pipelines and analysis outputs of population genetics, we constructed a pipeline to treat the population sequencing data, which can be easily used by the beginners.Briefly, the clean resequencing data after quality control and trimming was mapped to the reference genome. Following the genetic variability test of all the alignments, analyzation of population phylogeny, population structure, principal component analysis, and selective elimination were parallelly conducted, as well as estimation of the genetic diversity of each population. The resulting data were visualized by the R or Python scripts.
1.INSTALL
The new version will be updated and maintained in /xqteng/Re-seq_analysis, please click below website to download the latest version
Method1 For linux/Unix and macOS
git clone https://github.com/xqteng/Re-seq_analysis.git 
cd Re-seq_analysis

Method2 For linux/Unix and macOS
 tar -zxvf  Re-seq_analysisXXX.tar.gz
        cd Re-seq_analysisXXX;
2.USAGE
Parameter description
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
  -window-pi WP1, --wp1 WP1
                        the window size of Pi/Fst/xp-clr,default=5000
  -window-pi-step WPS1, --wps1 WPS1
                        the window step of Pi/Fst/xp-clr,default=2000
  -MF MF, --mf MF       the Minor Allele Frequency to filter snp,default=0.05
  -MM MM, --mm MM       the Max-missing rate,default=0.2
  -CHR CHR, --chr CHR   Chromosomes splited with "," e.g -CHR 1,2,3,4,5
  -K K, --k K           your belief of the number of ancestral populations
