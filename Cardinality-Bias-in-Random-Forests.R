# A series of simulations investigating cardinality bias in random forests
# See the README file for a complete description

set.seed(1234)

##########################################################################################

# Illustrate cardinality bias (null model)

Y <- factor(sample(1:2, 10000, r=T)) # binary
X1 <- factor(sample(1:2, 10000, r=T)) # binary
X2 <- factor(sample(1:4, 10000, r=T)) # 4 factor levels
X3 <- factor(sample(1:5, 10000, r=T)) # 5 factor levels
X4 <- factor(sample(1:10, 10000, r=T)) # 10 factor levels
X5 <- factor(sample(1:20, 10000, r=T)) # 20 factor levels
sim.1 <- cbind.data.frame(Y, X1, X2, X3, X4, X5); head(sim.1)

library(randomForest)
rf.1 <- randomForest(Y ~ ., data = sim.1, ntree = 1000); rf.1$importance # bias
rf.1 # As expected, around 50% accuracy (no better than chance)

library(ranger)
rf.2 <- ranger(Y ~ ., num.trees = 1000, 
               importance = 'impurity', data = sim.1); rf.2$variable.importance # bias
rf.2 # As expected, around 50% accuracy (no better than chance)

##########################################################################################

# Illustrate cardinality bias (Y and X1 are correlated)

X1 <- Y # overwrite X1 (make X1 a function in Y)
X1 <- ifelse(runif(10000) < 0.3, 1, ifelse(runif(10000) > 0.7, 2, X1)) # add noise
sim.2 <- cbind.data.frame(Y, X1, X2, X3, X4, X5)

# Fit a logistic regression using Y ~ X1
logit <- glm(Y ~ X1, data = sim.2, family = "binomial")

# Confusion matrix
CM.1 <- table(Y, as.numeric(predict(logit, within(sim.2, rm("X1")), 
                            type = "response") > 0.5)); CM.1
# Misclassification error
(10000 - sum(diag(CM.1)))/10000

# Fit a random forest using Y ~ X1
rf.3 <- randomForest(Y ~ X1, data = sim.2, ntree = 1000)

# Confusion matrix
CM.2 <- table(Y, as.numeric(predict(rf.3, within(sim.2, rm("Y")), 
                                    type = "response"))); CM.2

# Misclassification error
(10000 - sum(diag(CM.2)))/10000     # As expected, logit and RF agree for Y ~ X1.

# Now fit a random forest using Y ~ X1 + X2 + X3 + X4 + X5
rf.4 <- randomForest(Y ~ ., data = sim.2, ntree = 1000); rf.4$importance # bias

# Confusion matrix
CM.3 <- table(Y, as.numeric(predict(rf.4, within(sim.2, rm("Y")), 
                                    type = "response"))); CM.3

# Misclassification error
(10000 - sum(diag(CM.3)))/10000     

# We still observe bias, but prediction accuracy doesn't appear to suffer.

##########################################################################################

# Deterministic case
# Y is perfectly correlated with each predictor, but some predictors have more factors

Y <- sample(1:20, 10000, r=T)
X1=Y; X2=Y; X3=Y; X4=Y; X5=Y # X1:X5 are functions in Y
Y <- ifelse(Y <= 10, 0, 1) # Make Y binary

# X1 binary
X1 <- ifelse(X1 <= 10, 0, 1)

# X2 has 4 factor levels
X2 <- ifelse(X2 <= 5, 1, 
             ifelse(X2 <= 10, 2, 
                    ifelse(X2 <= 15, 3, 4)))

# X3 has 5 factor levels
X3 <- ifelse(X3 <= 4, 1, 
             ifelse(X3 <= 8, 2, 
                    ifelse(X3 <= 12, 3, 
                           ifelse(X3 <= 16, 4, 5))))

# X4 has 10 factor levels
X4 <- ifelse(X4 <= 2, 1, 
             ifelse(X4 <= 4, 2, 
                    ifelse(X4 <= 6, 3, 
                           ifelse(X4 <= 8, 4, 
                                  ifelse(X4 <= 10, 5, 
                                         ifelse(X4 <= 12, 6, 
                                                ifelse(X4 <= 14, 7, 
                                                       ifelse(X4 <= 16, 8, 
                                                              ifelse(X4 <= 18, 9, 10)))))))))

table(X1); table(X2); table(X3); table(X4); table(X5) # roughly equal proportions

sim.3 <- cbind.data.frame(Y, X1, X2, X3, X4, X5)
for (i in 1:ncol(sim.3)){sim.3[,i] <- as.factor(sim.3[,i])}
str(sim.3) # check structure

rf.5 <- ranger(Y ~ ., num.trees = 1000, 
               importance = 'impurity', data = sim.3); rf.5$variable.importance

# Cardinality bias is not observed when the variables are perfectly correlated.
# However, variable importance measures lose meaning when variables are colinear,
# as Leo Breiman noted in his paper introducing random forests.

# Confusion matrix
table(Y, predict(rf.5, within(sim.3, rm("Y")))$predictions) # perfect (as expected)

##########################################################################################

# Reduce accuracy for just two of the factor levels (5 , 17) in X5

X5 <- factor(ifelse(runif(10000) < 0.2, 5, 
             ifelse(runif(10000) > 0.8, 17, X5)))

sim.4 <- cbind.data.frame(Y, X1, X2, X3, X4, X5)

rf.6 <- ranger(Y ~ ., num.trees = 1000, 
               importance = 'impurity', data = sim.4); rf.6$variable.importance

# Measures of variable importance no longer claim X5 is important

table(Y, predict(rf.6, within(sim.4, rm("Y")))$predictions)

# The confusion matrix is still perfect

##########################################################################################

# Y is weakly correlated with each predictor, but some predictors have more factors

Y <- sample(1:20, 10000, r=T)
X1=Y; X2=Y; X3=Y; X4=Y; X5=Y

# Cannot figure out a more elegant way to do this.
# For some reason these functions don't work in a for loop.

# For X1:X5 about 5% of entries each agree with Y.
# The remainder are fully random.

# X1
  bin <- rbinom(10000, 1, 0.95)
  i1 <- which(bin != 1) 
  i2 <- which(bin == 1)
  bin[i1] <- Y[i1]
  bin[i2] <- sample(Y, length(i2), replace = T)
  X1 <- bin
# X2
  bin <- rbinom(10000, 1, 0.95)
  i1 <- which(bin != 1) 
  i2 <- which(bin == 1)
  bin[i1] <- Y[i1]
  bin[i2] <- sample(Y, length(i2), replace = T)
  X2 <- bin
# X3
  bin <- rbinom(10000, 1, 0.95)
  i1 <- which(bin != 1) 
  i2 <- which(bin == 1)
  bin[i1] <- Y[i1]
  bin[i2] <- sample(Y, length(i2), replace = T)
  X3 <- bin
# X4
  bin <- rbinom(10000, 1, 0.95)
  i1 <- which(bin != 1) 
  i2 <- which(bin == 1)
  bin[i1] <- Y[i1]
  bin[i2] <- sample(Y, length(i2), replace = T)
  X4 <- bin
# X5
  bin <- rbinom(10000, 1, 0.95)
  i1 <- which(bin != 1) 
  i2 <- which(bin == 1)
  bin[i1] <- Y[i1]
  bin[i2] <- sample(Y, length(i2), replace = T)
  X5 <- bin
   
# Y binary
Y <- ifelse(Y <= 10, 0, 1) 
# X1 binary
X1 <- ifelse(X1 <= 10, 0, 1)
# X2 has 4 factor levels
X2 <- ifelse(X2 <= 5, 1, 
             ifelse(X2 <= 10, 2, 
                    ifelse(X2 <= 15, 3, 4)))
# X3 has 5 factor levels
X3 <- ifelse(X3 <= 4, 1, 
             ifelse(X3 <= 8, 2, 
                    ifelse(X3 <= 12, 3, 
                           ifelse(X3 <= 16, 4, 5))))
# X4 has 10 factor levels
X4 <- ifelse(X4 <= 2, 1, 
             ifelse(X4 <= 4, 2, 
                    ifelse(X4 <= 6, 3, 
                           ifelse(X4 <= 8, 4, 
                                  ifelse(X4 <= 10, 5, 
                                         ifelse(X4 <= 12, 6, 
                                                ifelse(X4 <= 14, 7, 
                                                       ifelse(X4 <= 16, 8, 
                                                              ifelse(X4 <= 18, 9, 10)))))))))

table(X1); table(X2); table(X3); table(X4); table(X5)
sim.5 <- cbind.data.frame(Y, X1, X2, X3, X4, X5)
for (i in 1:ncol(sim.5)){sim.5[,i] <- as.factor(sim.5[,i])}; str(sim.5)

rf.7 <- ranger(Y ~ ., num.trees = 1000, 
               importance = 'impurity', data = sim.5); rf.7$variable.importance # bias

CM.4 <- table(Y, predict(rf.7, within(sim.5, rm("Y")))$predictions)
(10000 - sum(diag(CM.4)))/10000

# 26% error.

# Omit X5
rf.8 <- ranger(Y ~ X1 + X2 + X3 + X4, num.trees = 1000, 
               importance = 'impurity', data = sim.5); rf.8$variable.importance # bias
CM.5 <- table(Y, predict(rf.8, within(sim.5, rm("Y")))$predictions)
(10000 - sum(diag(CM.5)))/10000

# 42% error.

# Omit X1
rf.9 <- ranger(Y ~ X2 + X3 + X4 + X5, num.trees = 1000,
               importance = 'impurity', data = sim.5); rf.9$variable.importance # bias
CM.6 <- table(Y, predict(rf.9, within(sim.5, rm("Y")))$predictions)
(10000 - sum(diag(CM.5)))/10000

# 42% error.

# Conclude: prediction accuracy suffers when we remove one variable, but it does not
# seem to matter if we remove a high-cardinality variable or not, even in the presence
# of detectable cardinality bias.

##########################################################################################

# To do:
# Mix and match continuous variables and factors.
# Mix and match useful factor levels in a factor and not-useful factor levels.
# Test empirically if one-hot-encoding reduces prediction accuracy.