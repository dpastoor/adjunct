library(fiery)
source("R/execute.R")
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
    req_body <- jsonlite::fromJSON(request$rook.input$read_lines())
    message(req_body$code)
    maybe_parsed <- try_parse(req_body$code)
    message(maybe_parsed)
    if(maybe_parsed$had_error) {
        lines <- maybe_parsed$contents
    } else {
        lines <- readr::read_file("is_formed.html")
    }
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

