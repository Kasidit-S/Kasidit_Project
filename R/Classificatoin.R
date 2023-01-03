## Build logistic regression model
## build Model
split_data <- train_test_split(df,0.8)
train_data <- split_data[[1]]
test_data <- split_data[[2]]
nrow(train_data) ;nrow(test_data)

set.seed(42)

ctrl <- trainControl(
  method = "cv", ## Cross Validation
  number = 5,
  verboseIter = TRUE
)
glm_model <- train(diabetes ~ .,
                    data = train_data,
                    method ="glm",
                    metric = "Accuracy",
                    trControl = ctrl)

p4 <- predict(glm_model, newdata=test_data)

mean(p4 == test_data$diabetes)

confusionMatrix(p4,test_data$diabetes,
                positive = "pos",
                mode = "prec_recall")
