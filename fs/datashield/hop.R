library('opal')
o<-opal.login('administrator', 'password', 'http://localhost:8080')
datashield.assign(o,'PM_BMI_CONTINUOUS','opal-data.HOP:PM_BMI_CONTINUOUS')
datashield.symbols(o)
datashield.aggregate(o, 'summary(PM_BMI_CONTINUOUS)')
#datashield.summary(o,'PM_BMI_CONTINUOUS')

