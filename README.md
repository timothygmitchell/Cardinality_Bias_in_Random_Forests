# Cardinality_Bias_in_Random_Forests

Strobl *et al*. (2007) report bias in variable importance measures for random forests: namely, decision trees are more likely to select factors with more factor levels, even when the factors are equally important. As a consequence, factors with more factor levels (cardinality) tend to have higher variable importance measures. This bias is only observed for categorical variables.

This is illustrated in a simple simulation. Here I fit a random forest using 5 completely random predictors of increasing cardinality. While none of the predictors is useful at all for prediction, variable importance measures are highest for predictors with more factor levels!

This bias is concerning. But does it also affect accuracy? I am not aware of any systematic investigations into the matter. Here I developed several simulations to study cardinality bias under different conditions. Conditions include perfect and weak correspondence between the predictors and the response, with no noise and with considerable noise.

I find that while variable importance measures using Gini impurity are highly sensitive to cardinality bias, random forests are effective at selecting meaningful factors in the presence of real associations. This is a welcome finding, and I suspect it has to do with the regularizing properties of the ensemble. Cardinality bias calls into question the widespread use of variable importance measures for interpreting the model, but I am unable to find any decreases in accuracy.

Note: The scope of the simulations covers random forests for classification, not regression.

Citations:

Strobl, C., Boulesteix, A., Zeileis, A. et al. Bias in random forest variable importance measures: Illustrations, sources and a solution. *BMC Bioinformatics* **8**, 25 (2007). https://doi.org/10.1186/1471-2105-8-25
