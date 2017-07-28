setwd(getwd())
library(ggplot2)
library(FSelector)
library(e1071)
library(rpart)
library(readr)
library(dplyr)

# Student assessment data
studentAssessment <- read_csv("data/OULAD/studentAssessment.csv")
# Demographic data
studentInfo <- read.table(header = TRUE,sep = ",",'data/OULAD/studentInfo.csv')
studentRegistration <- read_csv("data/OULAD/studentRegistration.csv")
# testMerge = merge(studentInfo, studentAssessment, "id_student")

# join data based on student_id
studentScores <- merge(x = studentAssessment, y = studentInfo, by = "id_student")
# summary(subset(studentInfo, code_module=='FFF'))

# final_result "distinction" is considered excellence in this case
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

fit <- rpart(final_result ~ .,
             data=studentInfo,
             method="class")

printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# create additional plots 
par(mfrow=c(1,2)) # two plots on one page 
rsq.rpart(fit) # visualize cross-validation results 

plot(fit, uniform=TRUE, 
     main="Regression Tree for Student Info ")
text(fit, use.n=TRUE, all=TRUE, cex=.8)


