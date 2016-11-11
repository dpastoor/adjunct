library(fiery)

template_start <- c("---",
    "title: \"\"",
    "output: html_document",
    "---",
    "",
    "```{r setup, include=FALSE}",
    "knitr::opts_chunk$set(echo = TRUE, cache = T)",
    "```",
    "",
    "```{r}"
)

template_end <- c("```", "")


tstart <- Sys.time()
# Create a New App
app <- Fire$new()
app$host <- "127.0.0.1"
# Setup the data everytime it starts
app$on('start', function(server, ...) {
    message("listening on: ", paste(server$host, server$port, sep = ":"))
})


# Handle requests
app$on('request', function(server, id, request, ...) {
    lines <- readr::read_file("is_formed.html")
    list(
        status = 200L,
        headers = list('Content-Type' = 'text/html'),
        body = lines
    )
})


# Be polite
app$on('end', function(server) {
    message('Goodbye', difftime(Sys.time(), tstart))
})

app$ignite()

