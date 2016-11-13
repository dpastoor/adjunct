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
    post("/", function(req, res, err){
        print('received post')
        "Hello World!"
    }) %>%
    serve_it()