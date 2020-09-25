
#

library(shiny)
library(magick)
library (rtweet)
library(httr)
source ("function.r", local=TRUE)

keys <- list(
    app = "R app2",
    consumer_key = "bbhkBSZu3GSb5a7bbuOYSQrbU",
    consumer_secret = "p0ITn4OBdtNVNYKjl8Gg9TWcyNmxa1al6KVQsJQUClJSwjTFkg"
)


app <- httr::oauth_app(
    app = keys$app,
    key = keys$consumer_key,
    secret = keys$consumer_secret
)

# Define UI for application 
ui <- fluidPage(

    # Application title
    titlePanel("Create a new twitter avatar from the old and an activism image"),

    # Sidebar with a slider input for number of bins 
    


        # Show a plot of the generated distribution
        mainPanel(
            uiOutput("aouth")
            ,"default value for my twitter handle and the friday for future image from 25.09.2020"
        , shiny::textInput("twittername",label="write your twitter handle (without @)", value = "j_colomb")  
        ,shiny::textInput("bdg",label="url of the activism image", value = "https://www.klima-streik.org/fileadmin/_processed_/1/0/csm_KLIMASTREIK_September2020_Tweet-Bild_1200x677_08fe83181d.jpg")
        ,shiny::downloadButton("newavatar", label = "download your old and new avatars in a zip file.")
        ,tags$br()
        ,"This app is in beta mode, sorry if something is not working. It would be great to have a button to update your avatar directly, but this needs unfortunately much more work ..."
        ,tags$br(),
        "Give feedback, see more info (coming) at our "
        , HTML("<a href =https://github.com/OpenScienceMOOC/twittercampaign_app>GitHub page</a>")
        )
    
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    access_token <- reactive({
        
        # is the user is coming in from having just authenticated? 
        # if yes save the tokens, if not then no keys to user
        access_token <- NULL
        query <- getQueryString(session)
        if(!is.null(query) 
           && !is.null(query$oauth_token) 
           && !is.null(query$oauth_verifier)){ 
            access_token <- get_access_token(app, query$oauth_token, query$oauth_verifier)
        } 
        
        # turn the information from the file into a valid token object
        if(!is.null(access_token)){
            create_token(app=keys$app, 
                         keys$consumer_key, 
                         keys$consumer_secret, 
                         access_token = access_token$oauth_token, 
                         access_secret = access_token$oauth_token_secret)
        }
    })
    
    output$aouth <- renderUI({
        if(is.null(access_token())){
            url <- get_authorization_url(app= app, callback_url = "https://colomb.shinyapps.io/activism-twitteravatar")
            a(href = url, "Click here to authorize this app")
        } else {
            do.call(div,lapply(get_my_timeline(token = access_token())$text[1:3], p))
        }
    })
    
    output$newavatar <- downloadHandler(
        
        
        filename = function() {
            paste(input$twittername, "_avatar.zip", sep="")
        },
        content = function(file) {
            a= newtwitteravatar (tweetname= input$twittername, klimaimagepath=input$bdg)
            zip(file, c("images/avatar.jpg","images/newavatar.jpg"))
        }
    )
}


# Run the application 
shinyApp(ui = ui, server = server)
