setwd(getwd())
library(ggplot2)
library(FSelector) # information gain
library(e1071) # contains svm
library(rpart) # decision trees
library(readr)
library(cluster)
library(tidyverse)
library(FactoMineR) # PCA
library(factoextra) # distance and visualizations
library(mlr) # svm, boosting, random forests, nn..
library(class)

# Student assessment data -- Merges assessments and studentAssessments (student scores)
studentAssessment <- read_csv("data/OULAD/studentAssessment.csv")
assessments <- read_csv("data/OULAD/assessments.csv")
studentAssessment <- merge(x = studentAssessment,
                           y = assessments,
                           by = c("id_assessment"))

# Demographic data -- Merges studentInfo and studentRegistration information
studentInfo <- read.table(header = TRUE, sep = ",", 'data/OULAD/studentInfo.csv')
studentRegistration <- read_csv("data/OULAD/studentRegistration.csv")
demographics <- merge(x = studentInfo, 
                      y = studentRegistration, 
                      by = c("id_student","code_module", "code_presentation"))
# date_unregistration is a clear indicator that someone fails/withdraws
demographics <- subset(demographics, select = -c(date_unregistration))
# get results and id of the students
results <- subset(demographics, select = c(id_student, final_result, code_presentation))

# Assessments students with final_result
studentScores <- merge(x = studentAssessment,
                       y = results,
                       all.x = TRUE)
studentScores <- na.omit(studentScores)
studentScores <- subset(studentScores, select = -c(id_student, is_banked))
studentScores$final_result[studentScores$final_result =='Withdrawn'] <- 'Fail'
studentScores$final_result[studentScores$final_result =='Distinction'] <- 'Pass'

# Write CSV in R
# write.csv(studentScores, file = "data/custom/studentScores.csv", row.names = FALSE, na="")

scores2013 <- subset(studentScores, code_presentation == '2013B', select = -c(code_presentation))

dset <- head(studentScores, 3000)
trainset <- head(dset, 1000)
testset <- tail(dset, 2000)

# make all columns factors
# studentScores <- lapply( studentScores, factor)

# perform pca on dataset to find appropriate attributes to cluster
scores2013 <- lapply(scores2013, as.factor)
scores2013 <- data.frame(lapply(scores2013, as.numeric))
scores2013 <- head(scores2013, 50)
testPca <- PCA(scores2013, graph = FALSE)

fviz_pca_ind(testPca,
             label = "none",
             habillage = scores2013$final_result,
             palette = "Dark2",
             addEllipses = FALSE)

# scores2013 <- data.frame(matrix(unlist(scores2013), byrow=T))
# standardize the data
# k2 <- kmeans(scores2013, centers = 2, n = 25)

summary(demographics)
summary(studentScores)

