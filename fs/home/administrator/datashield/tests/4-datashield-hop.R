#!/usr/bin/env Rscript

#
# Do some datashield using dsbaseclient package on R client
#

library(dsbaseclient)
# http login
o1<-opal.login('administrator', 'password', 'http://localhost:8080')
# https login with ssl options
o2<-opal.login('administrator', 'password', 'https://localhost:8443',opts=list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3))
opals<-list(o1,o2)

cat("**** assign some opal variable values to R symbols...\n")
datashield.assign(opals,'PM_BMI_CONTINUOUS','opal-data.HOP:PM_BMI_CONTINUOUS')
datashield.assign(opals,'PM_BMI_CATEGORIAL','opal-data.HOP:PM_BMI_CATEGORIAL')
datashield.assign(opals,'PM_HEIGHT_MEASURE','opal-data.HOP:PM_HEIGHT_MEASURE')
datashield.assign(opals,'PM_WEIGHT_MEASURE','opal-data.HOP:PM_WEIGHT_MEASURE')
datashield.assign(opals,'SEX','opal-data.HOP:GENDER')

cat("**** get symbol length:\n")
datashield.length(opals, as.symbol('PM_BMI_CATEGORIAL'))

cat("**** display the symbols:\n")
datashield.symbols(opals)

cat("**** get some summaries:\n")
datashield.aggregate(opals, 'summary(PM_BMI_CONTINUOUS)')
datashield.aggregate(opals, 'summary(PM_BMI_CATEGORIAL)')

cat("**** other ways to get the summary:\n")
datashield.aggregate(opals, call('summary', as.symbol('PM_BMI_CATEGORIAL')))
datashield.summary(opals, as.symbol('PM_BMI_CATEGORIAL'))

#datashield.glm(opals, PM_BMI_CONTINUOUS ~ SEX + PM_HEIGHT_MEASURE + PM_WEIGHT_MEASURE, quote(binomial))

