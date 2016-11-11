
try_parse <- function(x) {
    result <-
        tryCatch({
          parse(text = x)
        }, error = function(e) {
            print("error in parsing")
            return(e)
        }, warning = function(w) {
            print("warning")
            return(w)
        }, finally = function() {
            print("looks good!")
        })

    browser()
    if (any("error" %in% class(result))) {
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
            print("error knitting")
            return(e)
        }, warning = function(w) {
            print("warning")
            return(w)
        }, finally = function() {
            print("looks good!")
        })

    if (any("error" %in% class(knit_result))) {
        # return the error as html
        print('failed parsing')
        return(list(had_error = TRUE, contents = knit_result$message))
    }
        return(list(had_error = FALSE, contents = knit_result))
}


