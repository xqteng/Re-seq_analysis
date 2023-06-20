library(cowplot)
fileheader <- "./Micropterus_salmoides_mergednocontig.plink."
n=5
layout(matrix(c(1:(n+1)), ncol = 1))##matirx()������ת���ɾ�����layout����ת��Ϊֱ��ͼ
par(mar = c(1.5, 4, 0, 0))##mar����ͼ�εı߽磬�£����ϣ��ң����������ҷֱ�յľ��룬
for (i in 1:n) {
  file = paste0(fileheader, as.character(i), ".Q")##paste0:ת��Ϊ�ַ�����������
  admixture_result = read.table(file)
  admixture_result
  barplot(
    t(as.matrix(admixture_result)),##t()����ת������
    col = rainbow(n),
    ylab = paste0("K =",i),
    xlab = "Individual",
    border = NA
  )
}
old <- par()
old$usr
populations=c("����","����","����","̩��","����","����","��")
p_size <- c(8,8,8,8,8,7,8)
i = (old$usr[2])/sum(p_size)
plot(NULL,xlim= c(0,old$usr[2]),ylim = c(0,1),axes=FALSE,ylab = '')
p_size[population]
for (population in 1:length(p_size)) {
  if (population == 1 ) {
    xleft = 0
  } else {
    xleft = sum(p_size[1:(population-1)])*i
  }
  rect(xleft,0,xleft+0.2+p_size[population]*i,1)
}
title(xlab = "Individual",
      line = 0.3,
      cex.lab = 1.2)
for (i in populations) {
  
  temp <- locator(1)
  text(temp,i,cex = 2.0)
}
