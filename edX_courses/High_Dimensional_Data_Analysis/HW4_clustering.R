

#------------------------Hierarchical Clustering Exercises------------------------
set.seed(1)
m = 10000
n = 24
x = matrix(rnorm(m*n),m,n)
colnames(x)=1:n

d <- dist(t(x))
hc <- hclust(d)

plot(hc)
abline(h=143)

ct = cutree(hc, h=143)

#if (!requireNamespace("multicon", quietly = TRUE))
#  install.packages("multicon")

table(true= colnames(x),cluster = ct)

nc = replicate(100,{
  x = matrix(rnorm(m*n),m,n)
  hc = hclust( dist( t(x)))
  length(unique(cutree(hc,h=143)))
})

plot(table(nc)) ## look at the distribution
popsd(nc)

#------------------------K-Means Exercises------------------------

library(GSE5859Subset)
data(GSE5859Subset)

set.seed(10)
km <- kmeans(t(geneExpression), centers = 5)


#-----------------------Heat Maps Exercises-----------------------

install.packages("matrixStats")
?rowMads ##we use mads due to a outlier sample

install.packages("gplots")

#Exercise 1

##load libraries
library(rafalib)
library(gplots)
library(matrixStats)
library(RColorBrewer)
##make colors
cols = colorRampPalette(rev(brewer.pal(11,"RdBu")))(25)
gcol=brewer.pal(3,"Dark2")
gcol=gcol[sampleInfo$g+1]

##make lables: remove 2005 since it's common to all
labcol= gsub("2005-","",sampleInfo$date)  

##pick highly variable genes:
sds =rowMads(geneExpression)
ind = order(sds,decreasing=TRUE)[1:25]

## make heatmap
heatmap.2(geneExpression[ind,],
          col=cols,
          trace="none",
          scale="row",
          labRow=geneAnnotation$CHR[ind],
          labCol=labcol,
          ColSideColors=gcol,
          key=FALSE)

#Exercise 2

set.seed(17)
m = nrow(geneExpression)
n = ncol(geneExpression)
x = matrix(rnorm(m*n),m,n)
g = factor(sampleInfo$g )


sds_x = rowMads(x)
ind_x = order(sds_x,decreasing=TRUE)[1:50]

## make heatmap
heatmap.2(x[ind_x,],
          col=cols,
          trace="none",
          scale="row",
          labCol=labcol,
          ColSideColors=gcol,
          key=FALSE)

library(devtools)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("genefilter")
library(genefilter)
 
rowt_x <- rowttests(x, factor(g))
ind_x2 = order(rowt_x,decreasing=FALSE)[1:50]

## make heatmap
heatmap.2(x[ind_x2,],
          col=cols,
          trace="none",
          scale="row",
          labRow=g,
          labCol=labcol,
          ColSideColors=gcol,
          key=FALSE)

