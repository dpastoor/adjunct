

try_parse <- function(x) {
    result <-
        tryCatch({
            parse(text = x)
        }, error = function(e) {
            print("error")
        }, warning = function(w) {
            print("warning")
        }, finally = function() {
            print("looks good!")
        })

    if (any(class(result) %in% "error")) {
        # return the error as html
        print('failed parsing')
        return(list(had_error = TRUE, contents = result$message))
    }

    return(list(had_error = FALSE, contents = TRUE))

}

try_knit <- function(file) {
    knit_result <-
        tryCatch({
        }, error = function(e) {
            print("error")
        }, warning = function(w) {
            print("warning")
        }, finally = function() {
            print("looks good!")
        })

    if (any(class(knit_result) %in% "error")) {
        # return the error as html
        print('failed parsing')
        return(list(had_error = TRUE, contents = knit_result$message))
    }
        return(list(had_error = FALSE, contents = knit_result))
}


