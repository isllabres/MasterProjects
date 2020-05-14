n = 1000
y = rbinom(n,1,0.25)
##proportion of ones Pr(Y)
sum(y==1)/length(y)
##expectaion of Y
mean(y)

#------------------------------------

set.seed(1)
men = rnorm(n,176,7) #height in centimeters
women = rnorm(n,162,7) #height in centimeters
y = c(rep(0,n),rep(1,n))
x = round(c(men,women))
##mix it up
ind = sample(seq(along=y))
y = y[ind]
x = x[ind]

#---------------------Exercise #1----------------------
#Is the mean when the height is 176

mean(y[x==176])

#---------------------Exercise #2----------------------

x0 = seq(160, 178)
means <- numeric(length = length(x0))

for (i in 1:length(x0))
{
  means[i] <- mean(y[x==x0[i]])
}

plot(x0,means)
abline(h=0.5)

#No entiendo por qué la respuesta es esa... pero bueno


#--------------------------Smoothing Exercises------------------
n = 10000
set.seed(1)
men = rnorm(n,176,7) #height in centimeters
women = rnorm(n,162,7) #height in centimeters
y = c(rep(0,n),rep(1,n))
x = round(c(men,women))
##mix it up
ind = sample(seq(along=y))
y = y[ind]
x = x[ind]

set.seed(5)
N = 250
ind = sample(length(y),N)
Y = y[ind]
X = x[ind]

ls <- loess(Y~X)

predict(ls, 168)

#-----------------------exercise 2----------------------------
library(multicon)
set.seed(5)

nc = replicate(1000,{
  ind = sample(length(y),N)
  Y = y[ind]
  X = x[ind]
  fit=loess(Y~X)
  fitted=predict(fit,newdata=data.frame(X=x0))
  estimate = predict(fit,newdata=data.frame(X=168))
  return(estimate)
})

popsd(nc)




#-----------------------Cross Validation----------------------------
#if (!requireNamespace("caret", quietly = TRUE))
#  install.packages("caret")
library(caret)
library(GSE5859Subset)
data(GSE5859Subset)

y = factor(sampleInfo$group)
X = t(geneExpression)
out = which(geneAnnotation$CHR%in%c("chrX","chrY"))
X = X[,-out]

set.seed(1)
idx <- createFolds(y, k=10)

#---------------------Exercise 1----------------------

idx[[3]][2]

