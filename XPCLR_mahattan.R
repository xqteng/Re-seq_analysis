rm(list=ls())
library(ggplot2)
mydat<-read.csv('C:/Users/Administrator/Desktop/hhhhh.csv')
#计算染色体刻度坐标
mydat$SNP <- seq(1, nrow(mydat), 1)
mydat$CHR <- factor(mydat$CHR, levels = unique(mydat$CHR))
chr <- aggregate(mydat$SNP, by = list(mydat$CHR), FUN = median)

col1<-c(rgb(078,098,171,200,maxColorValue=255))
col2<-c(rgb(214,064,078,200,maxColorValue=255))
col3<-c(rgb(253,179,046,200,maxColorValue=255))
col4<-c(rgb(219,049,036,200,maxColorValue=255))

#定义 p < 1e-05 为临界显著性，p < 5e-08 为高可信显著性
p <- ggplot(mydat, aes(SNP, -log(CLR, 10))) +
  annotate('rect', xmin = 0, xmax = max(mydat$SNP), ymin = -log10(1e-05), ymax = -log10(5e-08), fill = 'gray98') +
  geom_hline(yintercept = c(-log10(1e-05), -log10(5e-08)), color = c(col3,col4), size = 0.8) +
  geom_point(aes(color = CHR), show.legend = FALSE) +
  scale_color_manual(values = rep(c(col1, col2), 12)) +
  scale_x_continuous(breaks = chr$x, labels = chr$Group.1, expand = c(0, 0)) +
  theme(panel.grid = element_blank(), axis.line = element_line(colour = 'black'), panel.background = element_rect(fill = 'transparent')) +
  labs(x = 'Chromosome', y = expression(''~-log[10]~'(P)'))

p