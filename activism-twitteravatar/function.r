
newtwitteravatar <- function(tweetname= "j_colomb", klimaimagepath= "images/klima.jpg") {
  
  
  
  a=rtweet::lookup_users(tweetname)
  download.file(sub("_normal.", ".",a$profile_image_url),paste0("images/avatar.jpg"), mode ="wb")
  
  bgd =magick::image_read(klimaimagepath)%>% 
    magick::image_scale( "400x400")
  
  img=magick::image_read("images/avatar.jpg")%>% 
    magick::image_scale( "400x400")%>% 
    magick::image_convert("png")%>%
    magick::image_charcoal( radius = 1.8, sigma = 0.8) %>%
    magick::image_transparent( "white", fuzz = 20)
  
  imgnew <- c( bgd, img)
  
  magick::image_mosaic(imgnew) %>%
    magick::image_convert("jpg")%>%
    magick::image_write("images/newavatar.jpg")
}

oauth_sig <- function(url, method,
                      token = NULL,
                      token_secret = NULL,
                      private_key = NULL, ...) {
  httr::oauth_header(httr::oauth_signature(url, method, app, token,
                                           token_secret, private_key, other_params = list(...)))
}

# This function creates a URL for users to click to authenticate.
# You should use it to show a URL when users haven't authenticated yet.
# the callback_url HAS to be in the app configuration on the developer portal,
# and it needs to have the right http/https protocol.
# for testing in RSTudio I found it best to user 127.0.0.1 and have shiny use port 80
get_authorization_url <- function(app, callback_url, permission=NULL){
  private_key <- NULL
  response <- httr::POST("https://api.twitter.com/oauth/request_token", 
                         oauth_sig("https://api.twitter.com/oauth/request_token",
                                   "POST", private_key = NULL, oauth_callback = callback_url))
  httr::stop_for_status(response)
  params <- httr::content(response, type = "application/x-www-form-urlencoded")
  authorize_url <- httr::modify_url("https://api.twitter.com/oauth/authenticate",
                                    query = list(oauth_token = params$oauth_token, permission = permission))
  authorize_url
  
}

# Once a user authenticates them, Twitter will pass them back to the callback
# url in the authentication one, with the results of the authentication in the query
# of the callback url. This function takes the information from the query
# and does the final conversion to get it into the useful format
get_access_token <- function(app, oauth_token, oauth_verifier){
  url <- paste0("https://api.twitter.com/oauth/access_token?oauth_token=",
                oauth_token,"&oauth_verifier=",oauth_verifier)
  response <- httr::POST(url, 
                         oauth_sig(url,
                                   "POST",
                                   private_key = NULL))
  if(response$status_code == 200L){
    results <- content(response,type="application/x-www-form-urlencoded", encoding="UTF-8")
    
    results[["screen_name"]] <- NULL # since storing that might be creepy
    results[["user_id"]] <- NULL     # since storing that might be creepy
    
    results
  } else {
    NULL
  }
}
