#北京组学生物科技有限公司
#email: wangq@biomics.com.cn

#source("https://raw.githubusercontent.com/YinLiLin/CMplot/master/R/CMplot.r")
library(CMplot)
library(getopt)
#+--------------------
# get options
#+--------------------
spec <- matrix(c(
  'help', 'h', 0, "logical", "help",
  'binsize', 's', 1, "integer", "the size of bin for SNP_density plot, optional.",
  'color', 'c', 1, "character", " the colour for the SNP density, separated by ',', optional.",
  'name', 'n', 1, "character", "add a character to the output file name, optional.",
  'input', 'i', 1, "character", "vcf input file, forced.",
  'binmax', 'm', 1, "integer", "the max value of legend of SNP_density plot, the bin whose SNP number is bigger than 'bin.max' will be use the same color, optional."
), byrow = TRUE, ncol = 5)

opt <- getopt(spec)

#+--------------------
# check options
#+--------------------
if ( !is.null(opt$help) | is.null(opt$input) ) {
  cat(getopt(spec, usage=TRUE))
  q(status=1)
}
if ( is.null(opt$binsize ) )            { opt$binsize = 1e6 }
if ( is.null(opt$color ) )              { opt$color = "yellow,red" }
if ( is.null(opt$name ) )               { opt$name = "Fig1" }
if ( is.null(opt$binmax ) )            { opt$binmax = 500 }
#data(pig60K)
data <- read.table(opt$input, comment.char = "#", header = F, blank.lines.skip = T)
num <- dim(data)[1]
name <- paste("A", 1:num, sep = "")
snp <- data.frame(name,data[1],data[2])
colnames(snp) = c("SNP","Chromosome","Position")
color <- unlist(strsplit( opt$color, split = ","))

CMplot(
  snp, plot.type="d",  bin.size=opt$binsize, col=color, #xlab = "SNP",
  bin.range=c(1, opt$binmax),
  file="jpg", dpi=300, memo=opt$name, file.output=TRUE, verbose=TRUE
)
CMplot(
  snp, plot.type="d",  bin.size=opt$binsize, col=color,
  bin.range=c(1, opt$binmax),
  file="pdf", memo=opt$name, file.output=TRUE, verbose=TRUE
)
