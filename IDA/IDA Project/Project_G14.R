#IDA PROJECT

#NOTE:
#If the required packages are already installed then run the code as it is. 
#Otherwise,
#Uncomment these below lines for installing the required packages for this project.

#Optional packages installation
#install.packages("plotly")

#Mandatory packages installation

#install.packages("ggplot2")
#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages(GGally)
#install.packages(caTools)
#install.packages(MLmetrics)
#install.packages(caret)


# Using the installed packages
library(ggplot2)
library(tidyverse)
library(dplyr)
library(GGally)
library(caTools)
library(MLmetrics)
library(caret)

# Importing your .csv file
# Reading the data
dataset <- read.csv(file.choose(),header=TRUE)
summary(dataset)
str(dataset)

# Dropping the NaN values
dataset <- dataset %>% drop_na()
range(dataset$Life.expectancy)


# Dropping unnecessary values in the data
final_dataset <- dataset %>% select(Life.expectancy, Alcohol)

# Splitting data to 80% training data and 20% testing data 
split=sample.split(final_dataset, SplitRatio=0.8)
train<-subset(final_dataset,split==TRUE)       
test<-subset(final_dataset,split==FALSE)

# Checking dimensions of the training and testing
dim(final_dataset)
dim(train)
dim(test)



# 1st PART - CORRELATION ANALYSIS
# Correlation between variables without using In-built
x <- dataset$Alcohol
y <- dataset$Life.expectancy

m1 <- mean(x)
m2 <- mean(y)
size <- dim(dataset)

temp1 <- sum((x-m1) * (y-m2))/size[1]

s1<-sd(x)
s2<-sd(y)

temp2 <- s1*s2

coff <- temp1/temp2
sprintf("Co-efficient of Correlation is %f",coff)

# Correlation using In-built
data_num <- final_dataset %>% select_if(is.numeric)
ggcorr(data_num, 
       label = T, 
       label_size = 2,
       label_round = 2,
       hjust = 1,
       size = 3, 
       color = "royalblue",
       layout.exp = 5,
       low = "green3", 
       mid = "gray95", 
       high = "darkorange",
       name = "Correlation")




# 2 (a) - PERFORMING SIMPLE LINEAR REGRESSION
# Generate synthetic data with a clear linear relationship

#WITHOUT USING IN-BUILT

# Convert to dataframe
simple_lr_data <- data.frame(x, y)

# Calculate coefficients
b1 <- (sum((x - mean(x)) * (y - mean(y)))) / (sum((x - mean(x))^2))
b0 <- mean(y) - b1 * mean(x)

# Define function for generating predictions
simple_lr_predict <- function(x) {
  return(b0 + b1 * x)
}

# Apply simple_lr_predict() to input data
simple_lr_predictions <- sapply(x, simple_lr_predict)
simple_lr_data$yhat <- simple_lr_predictions

# Visualize input data and the best fit line without In-built
ggplot(data = simple_lr_data, aes(x = x, y = y)) +
  geom_point() +
  geom_line(aes(x = x, y = yhat), size = 1, color = "#0099f9") +
  theme_classic() +
  labs(
    title = "Applying Simple Linear Regression to data",
    subtitle = "Life Expectancy vs Alcohol"
  )

#USING IN-BUILT
# Visualizing best fit line using In-built 
ggplot(train, aes(Alcohol, Life.expectancy) ) +
  geom_point() +
  stat_smooth(method = lm, formula = y ~ x) +
  labs(
    title = "Applying Simple Linear Regression to data by using In-built",
    subtitle = "Life Expectancy vs Alcohol"
  )

predictions <- sapply(test$Alcohol, simple_lr_predict)

# Finding R Square value using formula
rss <- sum((predictions - test$Life.expectancy) ^ 2)  ## residual sum of squares
tss <- sum((test$Life.expectancy - mean(test$Life.expectancy)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
sprintf("R Square is %f",rsq)


# Finding R Square value using In-built
data.frame(
  RMSE = RMSE(predictions, test$Life.expectancy),
  R2 = R2(predictions, test$Life.expectancy)
)

# Finding R Square value using inbuilt correlation
RSQUARE = function(y_actual,y_predict){
  cor(y_actual,y_predict)^2
}

LR_R = RSQUARE(test$Life.expectancy,predictions)
sprintf("R Square using In-built is %f",LR_R)




# 2 (b) - Non Linear Regression
split=sample.split(final_dataset, SplitRatio=0.8)
train<-subset(final_dataset,split==TRUE)       
test<-subset(final_dataset,split==FALSE)

non_lr_data <- data.frame(x, y)

# Non Linear Regression to data without using In-built
non_lr_predict <- function(x) {
  return(8 + b0 + (0.4-b0)*exp(-b1*(x+2.3)))
}

non_lr_predictions <- sapply(x, non_lr_predict)
non_lr_data$yhat <- non_lr_predictions

ggplot(data = non_lr_data, aes(x = x, y = y)) +
  geom_point() +
  geom_line(aes(x = x, y = yhat), size = 1, color = "#0099f9") +
  theme_classic() +
  labs(
    title = "Applying Non Linear Regression to data without In-built",
    subtitle = "Life Expectancy vs Alcohol"
  )  + xlim(0, 20) + ylim(43, 90)



# Non Linear Regression to data using In-built
lm(Life.expectancy ~ poly(Alcohol, 4, raw = TRUE), data = train) %>%
summary()
model2 <- lm(Life.expectancy ~ poly(Alcohol, 4, raw = TRUE), data = train)

# Visualize input data and the best fit line 
ggplot(train, aes(Alcohol, Life.expectancy) ) +
  geom_point() +
  stat_smooth(method = lm, formula = y ~ poly(x, 4, raw = TRUE))

predictions2 <- model2 %>% predict(test)


# Model performance
# Finding R Square value using Formula
rss <- sum((predictions2 - test$Life.expectancy) ^ 2)  ## residual sum of squares
tss <- sum((test$Life.expectancy - mean(test$Life.expectancy)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq

# Finding R Square value using In-built
data.frame(
  RMSE = RMSE(predictions2, test$Life.expectancy),
  R2 = R2(predictions2, test$Life.expectancy)
)

# Finding R Square value using In-built Correlation
RSQUARE = function(y_actual,y_predict){
  cor(y_actual,y_predict)^2
}

LR_R = RSQUARE(test$Life.expectancy,predictions2)
sprintf("R Square using In-built is %f",LR_R)

#END

