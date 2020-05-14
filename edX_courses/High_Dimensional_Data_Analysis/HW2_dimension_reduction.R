#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("Biobase")

library(devtools)
install_github("genomicsclass/GSE5859Subset")

library(Biobase)
library(GSE5859Subset)
data(GSE5859Subset)

#PROJECTION EXERCISES

#We first load the data into y (just the first two samples/columns)

y = geneExpression[,1:2]

x <- seq(1, nrow(y), by=1)
y_plt <- t(y[,2])

plot(y[,1],y[,2])

z1 = (y[,1]+y[,2])/2 #the sum 
z2 = (y[,1]-y[,2]) #the difference
z = rbind( z1, z2) #matrix now same dimensions as y

plot(z[2,],z[1,])

#SVD EXERCISES

library(tissuesGeneExpression)
data(tissuesGeneExpression)

#svd solution is not unique due to sign change posibility

head(e)
head(tissue)

s = svd(e)
signflips = sample(c(-1,1),ncol(e),replace=TRUE)
signflips

newu= sweep(s$u,2,signflips,FUN="*")
newv= sweep(s$v,2,signflips,FUN="*" )
all.equal( s$u %*% diag(s$d) %*% t(s$v), newu %*% diag(s$d) %*% t(newv))

#--------------------exercise 1--------------------
#when we do SVD, we obtain d, u and v for e

cor(s$u[,1],m)

#--------------------exercise 2--------------------

newmeans = rnorm(nrow(e)) #random values we will add to create new means
newe = e+newmeans #we change the means
sqrt(crossprod(e[,3]-e[,45]))
sqrt(crossprod(newe[,3]-newe[,45]))

#Since the means do not change the distance between columns, we erase them

y = e - rowMeans(e)
s = svd(y)

resid = y - s$u %*% diag(s$d) %*% t(s$v)
max(abs(resid))

#We can easily see hoy d1 and d3 is the same operation as they say in the exercise

d1 = diag(s$d)%*%t(s$v)
d2 = s$d %*% t(s$v)[,1]
d3 = s$d * t(s$v)
d4 = t(s$d * s$v)
d5 = s$v * s$d

#--------------------exercise 3--------------------


vd = t(s$d * t(s$v))

op1 = tcrossprod(s$u,vd)
op2 = s$u %*% s$d * t(s$v)
op3 = s$u %*% (s$d * t(s$v))
op4 = s$u %*% t(vd)

#Option 2 has a matrix dimensions error since the priority of operations is sequential in this case
#So we are first computing 's$u %*% s$d' and then '* t(s$v)' 

#--------------------exercise 4--------------------

z = s$d * t(s$v)
sqrt(crossprod(e[,3]-e[,45]))
sqrt(crossprod(y[,3]-y[,45]))
sqrt(crossprod(z[,3]-z[,45]))

#because  U  is orthogonal, the distance between e[,3] and e[,45] is the same as the distance 
#between y[,3] and y[,45], which is the same as z[,3] and z[,45]

abs(sqrt(crossprod(z[1:2,3]-z[1:2,45])) - sqrt(crossprod(e[,3]-e[,45])))

#--------------------exercise 5--------------------

#Here we just change the dimensions of z we have to take in the last line of code until we reache 10% error or less

#--------------------exercise 6--------------------

distances = sqrt(apply(e[,-3]-e[,3],2,crossprod))

distances_z = sqrt(apply(z[1:2,-3]-z[1:2,3],2,crossprod))

cor(distances_z, distances, method = 'spearman')

