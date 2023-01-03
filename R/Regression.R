library(caret)
## Linear Regression
## ML basic pipeline
## fucntion split data
train_test_split <- function(data, train_size=0.8) {
  set.seed(42)
  n <- nrow(data)
  id <- sample(1:n, size=train_size*n)
  train_data <- data[id, ]
  test_data <- data[-id, ]
  return(list(train_data, test_data))
}

## 1. split data
split_data <- train_test_split(mtcars)
train_data <- split_data[[1]]
test_data <- split_data[[2]]

## 2. train model(method CV = Cross validation )

ctrl <- trainControl(method = "repeatedCV",  ## Resampling
                     number = 5, #k=5
                     repeats = 5,
                     verboseIter = TRUE)


model <- train(mpg ~ hp + wt,
               data = train_data,
               method = "lm",
               trControl = ctrl)

## 3. score model / prediction
p_mpg <- predict(model, newdata = test_data)


## 4. evaluate model
error <- p_mpg - test_data$mpg
( test_rmse <- sqrt(mean(error**2)))


## 5. save model (batch prediction)
saveRDS(model,"CV_model.RDS")


## 6. load model 
model <- readRSD("CV_model.RDS")

## 7. test new dataset
nov_data <- data.frame(
  id =1:3,
  hp =c(200, 150, 188),
  wt = c(2.5, 1.9, 3.2)
)
nov_prediction <- predict(model, newdata=nov_data)

nov_data$pred <- nov_prediction
write.csv(nov_data, "resultNov.csv",row.names = FALSE)
