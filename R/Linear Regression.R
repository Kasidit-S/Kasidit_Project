## Correlation
cor(mtcars$mpg, mtcars$hp)
cor(mtcars$wt, mtcars$mpg)

plot(mtcars$hp, mtcars$mpg, pch=16)
plot(mtcars$wt, mtcars$mpg, pch=16)
plot(mtcars$wt, mtcars$hp, pch=16)

cor(mtcars[,c("mpg", "wt", "hp")])


## dplyr(tidyverse)
library(dplyr)
mtcars %>%
  select(mpg, wt, hp, am) %>%
  cor()


## comute correlation (r) and sig test
cor(mtcars$hp,mtcars$mpg)
cor.test(mtcars$hp,mtcars$mpg)


## Linear Regression
## mpg = f(hp)

lmfit <- lm(mpg ~ hp, data = mtcars)

summary(lmfit)

lmfit$coefficients[[1]] + lmfit$coefficients[[2]]*200


new_cars <- data.frame(
  hp = c(250, 320, 400, 410, 450)
)


## predict
new_cars$mpg_pred <- predict(lmfit,newdata = new_cars)

new_cars$hp_pred <- NULL
new_cars
summary(mtcars$hp)

## RMSE (Root mean squared Error)
## Multiple Linear Regression
## mpg = f(hp, wt, am)
## mpg = intercept + b0*hp + b1*wt + b2*am

lmfit_v2 <- lm(mpg ~ hp + wt + am, data = mtcars)

coefs <- coef(lmfit_v2)
coefs[[1]] + coefs[[2]]*200 + coefs[[3]]*3.5 + coefs[[4]]*1

## build full model
lmfit_full <- lm(mpg ~ .- gear,data=mtcars)
mtcars$predicted <- predict(lmfit_full)

head(mtcars)

## RMSE
squared_error <- (mtcars$mpg - mtcars$predicted)**2

rmse <- sqrt(mean(squared_error))

## split Data
set.seed(42)
n <- nrow(mtcars)
id <- sample(1:n, size = n*0.8)
train_data <- mtcars[id, ]
test_data <- mtcars[-id, ]


## Train Model
model1 <- lm(mpg~ hp + wt, data = train_data)
p_train <- predict(model1)
error_train <- train_data$mpg - p_train
(rmse_train <- sqrt(mean(error_train**2)))

## Test Model
p_test <- predict(model1, newdata = test_data)
error_test <- test_data$mpg - p_test
(rmse_test <- sqrt(mean(error_test**2)))

## Print
cat("RMSE TRAIN:",rmse_train )
cat("RMSE TEST:",rmse_test )
