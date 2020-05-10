# Cardinality_Bias_in_Random_Forests

Strobl *et al*. (2007) report bias in variable importance measures for random forests: namely, decision trees are more likely to select factors (categorical variables) with more factor levels, even when the factors are equally important. As a consequence, factors with more factor levels (cardinality) tend to have higher variable importance measures.

This is illustrated in a simple simulation. Here I predict a response variable using 5 completely random predictors of increasing cardinality. While none of the predictors is useful for prediction, variable importance measures are higher for the predictors with more factor levels!

Cardinality bias has been known to the literature since 2007, but I was not aware of any systematic attempts to relate this bias to model accuracy. Here I developed several simulations to test cardinality bias under different conditions. Conditions include perfect and weak correlations between response and predictors, with no noise or with considerable noise.

I find that while variable importance measures using Gini impurity are sensitive to cardinality bias in many situations, random forests effectively prefer meaningful factors in the presence of real associations. This is a welcome finding, and I suspect it has to do with the regularizing properties of the bagging process. 

In conclusion, I am unable to produce a simulation in which cardinality bias negatively impacts accuracy, at least for the case the response is categorical. But it is clear that variable importance measures for factors are limited.

Citations:

Strobl, C., Boulesteix, A., Zeileis, A. et al. Bias in random forest variable importance measures: Illustrations, sources and a solution. *BMC Bioinformatics* **8**, 25 (2007). https://doi.org/10.1186/1471-2105-8-25
