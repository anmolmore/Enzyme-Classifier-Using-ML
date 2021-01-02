library(RSelenium)

#Ref : https://www.computerworld.com/article/2971265/how-to-drive-a-web-browser-with-r-and-rselenium.html

search.city <- 'hyderabad'
url <- paste0('http://zomato.com/',search.city)
search.location <- 'Gachibowli'

browser <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "firefox")
browser$open()
browser$navigate(url)

#find search box and enter search area
searchbox <- browser$findElement(using = 'id', "keywords_input")
searchbox$sendKeysToElement(list(search.location))

#Page takes a whole to to load
Sys.sleep(2)

#Click on search button and print title
searchbutton <- browser$findElement(using = 'id', "search_button")
searchbutton$clickElement()

print(browser$getCurrentUrl())
browser$close()