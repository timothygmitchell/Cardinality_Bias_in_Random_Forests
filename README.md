# Cardinality_Bias_in_Random_Forests

Strobl *et al*. (2007) report bias in variable importance measures for random forests: namely, decision trees are more likely to select factors (categorical variables) with more factor levels, even when the factors are equally important. As a consequence, factors with more factor levels (cardinality) tend to have higher variable importance measures.

This is illustrated in a simple simulation. Here I predict a response variable using 5 completely random predictors of increasing cardinality. While none of the predictors is useful for prediction, variable importance measures are higher for the variables with more factor levels!

This bias is concerning, but I am not aware of any systematic investigations of how this bias affects random forest accuracy. Here I developed several simulations to test cardinality bias under different conditions. Conditions include perfectly correlated and weakly correlated factors, with no noise and with considerable noise.

I find that while variable importance measures using Gini impurity are highly sensitive to cardinality bias, random forests are effective at selecting meaningful factors in the presence of real associations. This is a welcome finding, and I suspect it has to do with the regularizing properties of the ensemble. Cardinality bias calls into question the widespread use of variable importance measures for interpreting the model, but I am unable to find any decreases in accuracy.

Note: The scope of the simulations covers random forests for classification, not regression.

Citations:

Strobl, C., Boulesteix, A., Zeileis, A. et al. Bias in random forest variable importance measures: Illustrations, sources and a solution. *BMC Bioinformatics* **8**, 25 (2007). https://doi.org/10.1186/1471-2105-8-25
