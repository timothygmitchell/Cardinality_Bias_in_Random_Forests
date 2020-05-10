# Cardinality_Bias_in_Random_Forests

Strobl *et al*. (2007) report bias in variable importance measures for random forests. Namely, trees are more likely to select factors with more factor levels during node splitting, even when the factors are equally important. As a result, factors with more factor levels (cardinality) tend to have higher variable importance measures.

This is illustrated in a simple simulation. I fit a random forest using 5 completely random predictors of increasing cardinality. While none of the predictors was useful for prediction, variable importance measures were highest for the predictors with more factor levels!

This ‘cardinality bias’ has been known in the literature since at least 2007, but I was unaware of any publication or case studies relating this bias to model accuracy. Here I developed several simulations to test the effect of cardinality bias on model accuracy under different conditions. Conditions included perfect and weak correlations between predictors and response, with no noise or with considerable noise.

I found that random forests assign the highest variable importance to meaningful factors in the presence of real associations, notwithstanding cardinality bias. This is a welcome finding, and I suspect it has to do with the regularizing properties of the bagging process. The trees themselves may be biased, but the ensemble apparently is not.

In conclusion, I am unable to find a simulation in which cardinality bias negatively impacts accuracy. At the same time, variable importance measures for factors have clear limitations.

Citations:

Strobl, C., Boulesteix, A., Zeileis, A. et al. Bias in random forest variable importance measures: Illustrations, sources and a solution. *BMC Bioinformatics* **8**, 25 (2007). https://doi.org/10.1186/1471-2105-8-25
