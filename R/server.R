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
app$port <- 3000
# Setup the data everytime it starts
app$on('start', function(server, ...) {
    message("listening on: ", paste(server$host, server$port, sep = ":"))
})
app$header("Access-Control-Allow-Methods", 'POST, GET, PUT, OPTIONS, DELETE, PATCH')
app$header("Access-Control-Allow-Origin", '*')
app$header("Access-Control-Max-Age", '3600')
app$header("Access-Control-Allow-Headers", 'Origin, X-Requested-With, Content-Type, Accept')
# Handle requests
app$on('request', function(server, id, request, ...) {
    if (request$REQUEST_METHOD == "OPTIONS") {
        ## assuming this is preflight request check
        return(list(
            status=200L,
            headers=list(
                "Access-Control-Allow-Methods" = 'POST, GET, PUT, OPTIONS, DELETE, PATCH',
                "Access-Control-Allow-Origin" = '*',
                "Access-Control-Max-Age"= '3600',
                "Access-Control-Allow-Headers"='Origin, X-Requested-With, Content-Type, Accept'
            ),
            # also need body to satisfy fiery https://github.com/thomasp85/fiery/blob/master/R/Fire.R#L414
            body=""
        ))
    }

    req_body <- jsonlite::fromJSON(request$rook.input$read_lines())
    # in case submitted from windows
    req_body$code <- gsub("\\r\\n", "\\\n", req_body$code)
    maybe_parsed <- try_parse(req_body$code)

    if(maybe_parsed$had_error) {
        lines <- maybe_parsed$contents
    } else {
        file_name <- paste0(req_body$session_name, ".Rmd")
        readr::write_lines(c(template_start, req_body$code, template_end), file_name)
        maybe_knit <- try_knit(file_name)
        if(maybe_knit$had_error) {
            lines <- maybe_knit$contents
        } else {
            lines <- readr::read_file(paste0(req_body$session_name, ".html"))
        }
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

