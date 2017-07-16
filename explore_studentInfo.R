setwd(getwd())
library(ggplot2)
library(FSelector)

# Load student demographic information
studentInfo <- read.table(header = TRUE,sep = ",",'data/OULAD/studentInfo.csv')

# final_result "distinction" is considered excellence in this case
students2013 <- subset(studentInfo, code_presentation=='2013J' | code_presentation=='2013B')
students2014 <- subset(studentInfo, code_presentation=='2014J' | code_presentation=='2014B')
# find best attributes through information gain. final_result is the class attribute.
# force set units to log2 instead of log

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

prop.table(table(studentInfo$code_module, studentInfo$final_result))
