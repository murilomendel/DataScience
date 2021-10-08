library(dslabs)
data("tissue_gene_expression")
dim(tissue_gene_expression$x)
tissue_gene_expression$x[,1]
table(tissue_gene_expression$y)

d <- dist(tissue_gene_expression$x)

x_1 <- tissue_gene_expression$x[1,]
x_2 <- tissue_gene_expression$x[2,]

x_39 <- tissue_gene_expression$x[39,]
x_40 <- tissue_gene_expression$x[40,]

x_73 <- tissue_gene_expression$x[73,]
x_74 <- tissue_gene_expression$x[74,]

sqrt(crossprod(x_1 - x_2))
sqrt(crossprod(x_39 - x_40))
sqrt(crossprod(x_73 - x_74))

ind <- c(1, 2, 39, 40, 73, 74)
as.matrix(d)[ind, ind]


image(as.matrix(d))
