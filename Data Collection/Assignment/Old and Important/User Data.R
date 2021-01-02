# Iterate through each users page, and collect metadata related to reviews count, followers count, photos count

# Append values to reviews dataframe

```{r}
GetUsersMetadata <- function(reviews.df) {
  tryCatch({
    for (id in reviews.df$UserId) {
      user.url <- paste0("https://www.zomato.com/users/",id)
      print(user.url)
      html_page <- user.url %>% read_html()
      
      user.metadata.total.reviews.count <- html_page %>% html_node('.user-tab-reviews .ui.label') %>% html_text()
      user.metadata.followers.count <- html_page %>% html_node('.user-tab-follows .ui.label') %>% html_text()
      user.metadata.photos.count <- html_page %>% html_node('.user-tab-photos .ui.label') %>% html_text()
      
      reviews.df[reviews.df$UserId == id, "Reviews Count"] <- user.metadata.total.reviews.count
      reviews.df[reviews.df$UserId == id, "Followers Count"] <- user.metadata.followers.count
      reviews.df[reviews.df$UserId == id, "Photos Count"] <- user.metadata.photos.count
      
      Sys.sleep(10)
    }
  }, error = function(NoSuchElementException) {
    message("Error in fetching reviews, skip and continue !")
  })
  return(reviews.df)
}
```
