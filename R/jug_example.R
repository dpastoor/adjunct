library(jug)
jug() %>%
    use("/", function(req, res, err){
        res$set_header("Access-Control-Allow-Methods", 'POST, GET, PUT, OPTIONS, DELETE, PATCH')
        res$set_header("Access-Control-Allow-Origin", '*')
        res$set_header("Access-Control-Max-Age", '3600')
        res$set_header("Access-Control-Allow-Headers", 'Origin, X-Requested-With, Content-Type, Accept')
        ""
    }, method="OPTIONS") %>%
    cors() %>%
    serve_static_files(root_path = "/Users/devin/Repos/testts/build/") %>%
    post("/api/v1/", function(req, res, err){
        print(req)
        req_body <- jsonlite::fromJSON(req$body)
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
        res$set_status(200L)
        res$content_type('text/html')
        res$text(lines)
        res
    }) %>%
    serve_it()