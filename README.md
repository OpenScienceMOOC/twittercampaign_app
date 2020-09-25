# twittercampaign_app
I would like an app that when I click a button, my profile picture is changed and a tweet is sent saying I am on strike for the day. Who want to help build this?


The tricky part to do it in R/shiny is pushing the image to the profile, as no rtweet function can do that (yet).

# updates

this is not yet a package:

-install magick and rtweet packages, 
- download or copy the function.r file,
- run it and then do

`newtwitteravatar(tweetname= "your twitter name")`

it will create a new avatar for you to upload on twitter at images/newavatar.