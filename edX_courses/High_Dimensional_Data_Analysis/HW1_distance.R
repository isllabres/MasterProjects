library(devtools)
install_github("genomicsclass/tissuesGeneExpression")

library(tissuesGeneExpression)
data(tissuesGeneExpression)
head(e)
head(tissue)

#Question 1

table(tissue)

#Question 2 (Using two diff methods for distance)

x <- e[,3]
y <- e[,45]

dist1 <- sqrt(sum((x-y)^2))
dist2 <- sqrt(crossprod(x-y))

#Question 3

z <- e[c("210486_at"),]
t <- e[c("200805_at"),]

dist3 <- sqrt(crossprod(z-t))

#Question 4

#We can't run the code since it will crush our R session
#d = as.matrix(dist(e))
#we will be computing a matrix os 22215x22215 (493506225 distances)

#Question 5

d = dist(t(e))

length(d)
