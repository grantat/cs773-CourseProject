setwd(getwd())
library(ggplot2)
library(FSelector) # information gain
library(e1071)
library(rpart)
library(readr)
library(dplyr)

 
# Student assessment data -- Merges assessments and studentAssessments (student scores)
studentAssessment <- read_csv("data/OULAD/studentAssessment.csv")
assessments <- read_csv("data/OULAD/assessments.csv")
studentAssessment <- merge(x = studentAssessment,
                           y = assessments,
                           by = c("id_assessment"))
# Demographic data -- Merges studentInfo and studentRegistration information
studentInfo <- read.table(header = TRUE,sep = ",",'data/OULAD/studentInfo.csv')
studentRegistration <- read_csv("data/OULAD/studentRegistration.csv")

# Join demographic data together
demographics <- merge(x = studentInfo, 
                      y = studentRegistration, 
                      by = c("id_student","code_module", "code_presentation"))
demographics <- subset(demographics, select = -c(date_unregistration))

didFail <- subset(demographics, select = c(id_student, final_result))
# Assessments students with final_result
studentScores <- merge(x = studentAssessment,
                       y = didFail,
                       by = c("id_student"),
                       all.x = TRUE)
studentScores <- na.omit(studentScores)
studentScores <- subset(studentScores, select = -c(id_student))

summary(demographics)
summary(studentScores)
# break data down by semester
semesters <- c('2013B','2013J','2014B','2013J')

scoreWeights <- information.gain(final_result~., data=studentScores, unit="log2")
# Just to check the information gain of the attributes, student_ids and date_unregistration isn't helpful so remove them
demoAttrs <- subset(demographics, select = -c(id_student))
# summary(subset(studentInfo, code_module=='FFF'))

# demographic attribute weights
demoWeights <- information.gain(final_result~., data=demoAttrs, unit="log2")

students2013 <- subset(studentInfo, code_presentation=='2013J' | code_presentation=='2013B')
students2014 <- subset(studentInfo, code_presentation=='2014J' | code_presentation=='2014B')

# find best attributes through information gain. final_result is the class attribute.
allWeights <- information.gain(final_result~., data=studentInfo, unit="log2")
weights2013 <- information.gain(final_result~., data=students2013, unit="log2")
weights2014 <- information.gain(final_result~., data=students2014, unit="log2")

# There really is no difference between 2013, 2014 and all info gains.
# From what we see the top four features are:
# core_module, studied_credits, highest_education and imd_band

print("2013")
print(summary(students2013$final_result))
print("2014")
print(summary(students2014$final_result))
print("all students")
print(summary(studentInfo$final_result))

# kmeans on studentScores

