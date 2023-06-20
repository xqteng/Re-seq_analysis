##读取PCA结果矩阵
library(scatterplot3d)

val1 = read.table(file = "C:/Users/XQT/Desktop/analysefiles/snp_softfiltered.plink.eigenvec")
scatterplot3d(val1[,3:5],pch = 16, color="steelblue",
              main="PCA ANALYSE",
              xlab = "pca1",
              ylab = "pca2",
              zlab = "pca3")
while (!is.null(dev.list()))  dev.off()

##读取PCA结果矩阵
library(scatterplot3d)
val1 = read.table(file = "GF_merge_new_ABCDN.eigenvec")
p1 <-scatterplot3d(val1[,3:5],pch = 16, color="steelblue",
              main="PCA ANALYSE",
              xlab = "pca1",
              ylab = "pca2",
              zlab = "pca3")
text(p1$xyz.convert(val1[, 3:5]), labels = rownames(val1),
     cex= 0.7, col = "black")
while (!is.null(dev.list()))  dev.off()
