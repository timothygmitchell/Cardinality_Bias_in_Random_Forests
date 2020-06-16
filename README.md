# Cardinality_Bias_in_Random_Forests

[Strobl *et al*. (2007)](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-8-25) report bias in variable importance measures for random forests. Namely, trees are more likely to select factors with more factor levels during node splitting, even when the factors are equally important. As a result, factors with more factor levels (cardinality) tend to have higher variable importance measures.

This is illustrated in a simple simulation. I fit a random forest using 5 completely random predictors of increasing cardinality. While none of the predictors was useful for prediction, variable importance measures were highest for the predictors with more factor levels!

This cardinality bias has been known in the literature since at least 2007, but I was unaware of any publication or case studies relating this bias to model accuracy. Here I developed several simulations to test the effect of cardinality bias on model accuracy under different conditions. I simulated perfect and weak correlations between the predictors and response, with no noise or with considerable noise.

I found that for each simulation, model accuracy depended on the strength of the association between the response and the meaningful factor(s), even when bias was observed. In conclusion, cardinality bias does not seem to impact model accuracy. I suspect this has something to do with the regularizing properties of the bagging process. That is, the ensemble must smooth out the bias in the individual trees.

Variable importance measures for factors have clear limitations. I was able to produce many simulations in which cardinality bias influenced variable importance measures, even in the presence of real associations.

Citations:

Strobl, C., Boulesteix, A., Zeileis, A. et al. Bias in random forest variable importance measures: Illustrations, sources and a solution. *BMC Bioinformatics* **8**, 25 (2007). https://doi.org/10.1186/1471-2105-8-25
