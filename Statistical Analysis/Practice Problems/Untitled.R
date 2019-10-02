library(rvest)
library(RSelenium)
library(stringr)
library(xm12)
library(wdman)
url <- "https://www.social-enterprise.nl/wie-doen-het/" 

remDr <- remoteDriver()
# Open the browser webpage
remDr$open()

#navigate to your page
remDr$navigate(url)

# Locate the load more button
loadmorebutton <- remDr$findElement(using = 'css selector', "#morenews")

for (i in 1:2){
  print(i)
  loadmorebutton$clickElement()
  Sys.sleep(30)
}
page_source<-remDr$getPageSource()

Merken <- read_html(page_source[[1]]) %>% 
  html_nodes("#membershipCntr span") %>%
  html_text()
remDr$close()