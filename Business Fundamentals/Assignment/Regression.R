library(MASS)
basicreg <- function(X,y) {
  regdata <- lm(y ~ X)
  coef <- summary(regdata)#$coefficients[2,1]
  return(coef)
}

historical.data <- read.csv("Regression.csv")

print("Reliance Beta")
print(basicreg(historical.data$NSE.Return, historical.data$Reliance.Return))

print("HDFC Beta")
print(basicreg(historical.data$NSE.Return, historical.data$HDFC.Return))

