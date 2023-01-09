##曼哈顿图
#install.packages("qqman")
library(qqman)
manhattan <-  function (x, chr = "CHR", bp = "BP", p = "P", 
                        snp = "SNP", col = c("black", "grey"), 
                        chrlabs = NULL, suggestiveline = TRUE, genomewideline = FALSE, 
                        highlight = NULL, logp = FALSE, annotatePval = NULL, annotateTop = TRUE, 
                        ...) 
{
  CHR = BP = P = index = NULL
  if (!(chr %in% names(x))) 
    stop(paste("Column", chr, "not found!"))
  if (!(bp %in% names(x))) 
    stop(paste("Column", bp, "not found!"))
  if (!(p %in% names(x))) 
    stop(paste("Column", p, "not found!"))
  if (!(snp %in% names(x))) 
    warning(paste("No SNP column found. OK unless you're trying to highlight."))
  if (!is.numeric(x[[chr]])) 
    stop(paste(chr, "column should be numeric. Do you have 'X', 'Y', 'MT', etc? If so change to numbers and try again."))
  if (!is.numeric(x[[bp]])) 
    stop(paste(bp, "column should be numeric."))
  if (!is.numeric(x[[p]])) 
    stop(paste(p, "column should be numeric."))
  d = data.frame(CHR = x[[chr]], BP = x[[bp]], P = x[[p]])
  if (!is.null(x[[snp]])) 
    d = transform(d, SNP = x[[snp]])
  d <- subset(d, (is.numeric(CHR) & is.numeric(BP) & is.numeric(P)))
  d <- d[order(d$CHR, d$BP), ]
  if (logp) {
    d$logp <- -log10(d$P)
  }
  else {
    d$logp <- d$P
  }
  d$pos = NA
  d$index = NA
  ind = 0
  for (i in unique(d$CHR)) {
    ind = ind + 1
    d[d$CHR == i, ]$index = ind
  }
  nchr = length(unique(d$CHR))
  if (nchr == 1) {
    d$pos = d$BP
    ticks = floor(length(d$pos))/2 + 1
    xlabel = paste("Chromosome", unique(d$CHR), "position")
    labs = ticks
  }
  else {
    lastbase = 0
    ticks = NULL
    for (i in unique(d$index)) {
      if (i == 1) {
        d[d$index == i, ]$pos = d[d$index == i, ]$BP
      }
      else {
        lastbase = lastbase + tail(subset(d, index == 
                                            i - 1)$BP, 1)
        d[d$index == i, ]$pos = d[d$index == i, ]$BP + 
          lastbase
      }
      ticks = c(ticks, (min(d[d$index == i, ]$pos) + max(d[d$index == 
                                                             i, ]$pos))/2 + 1)
    }
    xlabel = "Chromosome"
    labs <- unique(d$CHR)
  }
  xmax = ceiling(max(d$pos) * 1.03)
  xmin = floor(max(d$pos) * -0.03)
  def_args <- list(xaxt = "n", bty = "n", xaxs = "i", 
                   yaxs = "i", las = 1, pch = 20, xlim = c(xmin, xmax), 
                   ylim = c(0, ceiling(max(d$logp))), xlab = xlabel, ylab = "Fst")
  dotargs <- list(...)
  do.call("plot", c(NA, dotargs, def_args[!names(def_args) %in% 
                                            names(dotargs)]))
  if (!is.null(chrlabs)) {
    if (is.character(chrlabs)) {
      if (length(chrlabs) == length(labs)) {
        labs <- chrlabs
      }
      else {
        warning("You're trying to specify chromosome labels but the number of labels != number of chromosomes.")
      }
    }
    else {
      warning("If you're trying to specify chromosome labels, chrlabs must be a character vector")
    }
  }
  if (nchr == 1) {
    axis(1, ...)
  }
  else {
    axis(1, at = ticks, labels = labs, ...)
  }
  col = rep(col, max(d$CHR))
  if (nchr == 1) {
    with(d, points(pos, logp, pch = 20, col = col[1], ...))
  }
  else {
    icol = 1
    for (i in unique(d$index)) {
      with(d[d$index == unique(d$index)[i], ], points(pos, 
                                                      logp, col = col[icol], pch = 20, ...))
      icol = icol + 1
    }
  }
  if (suggestiveline) 
    #标注线
    abline(h = divid_percent(x$LR,0.999), col = "blue")
  if (genomewideline) 
    abline(h = genomewideline, col = "red")
  if (!is.null(highlight)) {
    if (any(!(highlight %in% d$SNP))) 
      warning("You're trying to highlight SNPs that don't exist in your results.")
    d.highlight = d[which(d$SNP %in% highlight), ]
    with(d.highlight, points(pos, logp, col = "green3", 
                             pch = 20, ...))
  }
  if (!is.null(annotatePval)) {
    topHits = subset(d, P <= annotatePval)
    par(xpd = TRUE)
    if (annotateTop == FALSE) {
      with(subset(d, P <= annotatePval), textxy(pos, -log10(P), 
                                                offset = 0.625, labs = topHits$SNP, cex = 0.45), 
           ...)
    }
    else {
      topHits <- topHits[order(topHits$P), ]
      topSNPs <- NULL
      for (i in unique(topHits$CHR)) {
        chrSNPs <- topHits[topHits$CHR == i, ]
        topSNPs <- rbind(topSNPs, chrSNPs[1, ])
      }
      textxy(topSNPs$pos, -log10(topSNPs$P), offset = 0.625, 
             labs = topSNPs$SNP, cex = 0.5, ...)
    }
  }
  par(xpd = FALSE)
}

divid_percent <- function(x,percent) {
  temp <- round(length(x)*percent)
  return(sort(x)[temp])
}

datalist = #c("DH_vs_ZJ.windowed.weir.fst")
           # c("YZ_vs_ZJ.windowed.weir.fst")
           c("DH_vs_YZ.windowed.weir.fst")

#datalist = c("fst_pi/popD_vs_popA.windowed.weir.fst",
  #           "fst_pi/popD_vs_popB.windowed.weir.fst")
for (file in datalist){
  Fst_preman <- na.omit(read.table(file,header = T)) 
  Fst_man <- cbind.data.frame(Fst_preman$CHROM,Fst_preman$BIN_START,Fst_preman$WEIGHTED_FST)
  colnames(Fst_man) <- c("CHR","BP","FST")
  Fst_man$CHR <- as.integer(gsub("LG","",Fst_man$CHR))
  Fst_man$BP <- floor(Fst_man$BP/1000)+1
  Fst_man$SNP <- paste0(Fst_man$CHR,"_",Fst_man$BP)
  ylim = max(1)
  

  
  png(file=paste0(file,".Fst_man0.0511.png"),bg = "white",width = 297,height = 210,units = "mm",res = 300)
  manhattan(Fst_man,chr = "CHR",bp = "BP",p = "FST",snp = "SNP",logp = F,ylim =c(0,ylim),genomewideline = divid_percent(Fst_man$FST,0.95) )
  dev.off()
}

