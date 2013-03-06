library('opal')
o<-opal.login('administrator', 'password', 'http://localhost:8080')
datashield.assign(o,'PM_BMI_CONTINUOUS','opal-data.HOP:PM_BMI_CONTINUOUS')
datashield.assign(o,'PM_BMI_CATEGORIAL','opal-data.HOP:PM_BMI_CATEGORIAL')
datashield.symbols(o)
datashield.aggregate(o, 'summary(PM_BMI_CONTINUOUS)')
datashield.aggregate(o, 'summary(PM_BMI_CATEGORIAL)')
datashield.aggregate(o, call('summary', as.symbol('PM_BMI_CATEGORIAL')))
datashield.length(o, as.symbol('PM_BMI_CATEGORIAL'))
datashield.summary(o, as.symbol('PM_BMI_CATEGORIAL'))
datashield.histogram(o, as.symbol('PM_BMI_CONTINUOUS'))

# unrestricted mode
datashield.aggregate(o, 'search()')
datashield.aggregate(o, 'devtools::install_github("dsbase","datashield")')

# with demo
o2<-opal.login('administrator', 'password', 'http://demo.obiba.org:8080')
opals<-list(o,o2)

# https with ssl options
o<-opal.login('administrator', 'password', 'https://localhost:8443',opts=list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3))