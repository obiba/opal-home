library('opal')
o<-opal.login('administrator', 'password', 'http://localhost:8080')
datashield.assign(o,'PM_BMI_CONTINUOUS','opal-data.HOP:PM_BMI_CONTINUOUS')
datashield.assign(o,'PM_BMI_CATEGORIAL','opal-data.HOP:PM_BMI_CATEGORIAL')
datashield.symbols(o)
datashield.aggregate(o, 'summary(PM_BMI_CONTINUOUS)')
datashield.aggregate(o, 'summary(PM_BMI_CATEGORIAL)')


