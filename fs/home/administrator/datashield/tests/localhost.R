library(opal)

server <- c("local")
url <- c("https://localhost:8443")
user <- c("datashield-publickey.pem")
password <- c("datashield-privatekey.pem")
table <- c("onyx.AnkleBrachial")
logindata <- data.frame(server,url,user,password,table)

#options(verbose=TRUE)
opals <- datashield.login(logins=logindata,assign=TRUE)