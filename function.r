
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

newtwitteravatar()