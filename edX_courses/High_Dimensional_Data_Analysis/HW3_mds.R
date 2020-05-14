library(tissuesGeneExpression)
data(tissuesGeneExpression)

y = e - rowMeans(e)
s = svd(y)
z = s$d * t(s$v)

#--------------------exercise 1--------------------

#if (!requireNamespace("rafalib", quietly = TRUE))
#  install.packages("rafalib")

library(rafalib)
ftissue = factor(tissue)
mypar(1,1)
plot(z[1,],z[2,],col=as.numeric(ftissue))
legend("topleft",levels(ftissue),col=seq_along(ftissue),pch=1)

d = dist(t(e))
mds = cmdscale(d)

cor(z[1,], mds[,1])

#--------------------exercise 2--------------------

cor(z[2,], mds[,2])


#--------------------exercise 3--------------------

library(rafalib)
ftissue = factor(tissue)
mypar(1,2)
plot(z[1,],z[2,],col=as.numeric(ftissue))
legend("topleft",levels(ftissue),col=seq_along(ftissue),pch=1)
plot(mds[,1],mds[,2],col=as.numeric(ftissue))


ftissue = factor(tissue)
mypar(1,2)
plot(-1*z[1,],-1*z[2,],col=as.numeric(ftissue))
legend("topleft",levels(ftissue),col=seq_along(ftissue),pch=1)
plot(mds[,1],mds[,2],col=as.numeric(ftissue))

#--------------------exercise 4, 5, 6--------------------

library(GSE5859Subset)
data(GSE5859Subset)

s = svd(geneExpression-rowMeans(geneExpression))
z = s$d * t(s$v)

sampleInfo$group

abs(cor(t(z), sampleInfo$group))

#--------------------exercise 7--------------------

month = format( sampleInfo$date, "%m")
month = factor( month)

max(abs(cor(t(z), as.numeric(month))))

#--------------------exercise 8--------------------

x <- s$u[,6]

result = split(x,geneAnnotation$CHR)
result = result[ which(names(result)!="chrUn") ]

boxplot(result,range=0)
boxplot(result,range=0,ylim=c(-0.025,0.025))

medians = sapply(result,median)
names(result)[ which.max(abs(medians)) ]