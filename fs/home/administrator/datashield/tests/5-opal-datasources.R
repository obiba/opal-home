#!/usr/bin/env Rscript

#
# Opal R client
#

library(opal)
# http login
#o<-opal.login('administrator', 'password', 'http://localhost:8080')
# https login with ssl options
o<-opal.login('administrator', 'password', 'https://localhost:8443',opts=list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3))

cat("**** datasources:\n")
opal.datasources(o)
cat("**** opal-data datasource:\n")
opal.datasource(o,'opal-data')
cat("**** opal-data datasource tables:\n")
opal.tables(o,'opal-data')
cat("**** opal-data datasource HOP table:\n")
opal.table(o,'opal-data','HOP')
cat("**** opal-data datasource HOP table GENDER variables:\n")
opal.variables(o,'opal-data','HOP')
cat("**** opal-data datasource HOP table GENDER variable:\n")
opal.variable(o,'opal-data','HOP','GENDER')
cat("**** missing variable:\n")
opal.variable(o,'opal-data','HOP','XXXX')

cat("**** assign some variables:\n")
opal.assign(o,'SEX','opal-data.HOP:GENDER')
opal.assign(o,'BMI','opal-data.HOP:PM_BMI_CONTINUOUS')
opal.symbols(o)

cat("**** execute some summary:\n")
opal.execute(o,'length(SEX)')
opal.execute(o,'summary(SEX)')
opal.execute(o,'summary(BMI)')

cat("**** clean symbols:\n")
opal.rm(o,'SEX')
opal.rm(o,'BMI')
opal.symbols(o)
