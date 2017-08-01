setwd(getwd())
library(ggplot2)
library(FSelector)
library(e1071)
library(rpart)
library(readr)
library(dplyr)


weightedAssess <- read_csv("data/custom/WeightedAssessmentsClicks2.csv")

allWeights <- information.gain(final_result~., data=weightedAssess, unit="log2")

summary(weightedAssess)

weight100 <- subset(weightedAssess, weightedAssess$Weight == 100)
sum(weight100$final_result == 'Fail' & weight100$Score < 50)
sum(weight100$final_result == 'Pass')

studentAssessments <- read_csv("data/custom/studentAssessment2.csv")
assessmentGain <- information.gain(final_result~., data=studentAssessments, unit = "log2")