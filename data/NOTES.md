# Data notes

Generalize the studentInfo into two parts, pass and fail.
Where Pass includes Pass and Distinction.
Where Fail includes Fail and Withdrawn

Looking through the demographic information, studentInfo.csv and studentRegistration.csv,
alone we can't derive enough information to predict if a student passes or fails.

Information gain on studentInfo:

code_module
0.0333132948
studied_credits
0.0291538626
highest_education
0.0220755496
imd_band
0.0190484622
num_of_prev_attempts
0.0112197577
region
0.0099021067
code_presentation
0.0090550367
age_band
0.0047750479
id_student
0.0041076257
disability
0.0030386879
gender
0.0003658152

Information gain on studentRegistration:


Each instance of data alone is almost useless
