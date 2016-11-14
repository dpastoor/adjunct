
# use the output from the system utility mimetype if available
# modified from yihui servr code
# valuable for a R based static file server
guess_type <- function(path) {
    mimetype <- function(...) {
        system2('mimetype', c('-b', shQuote(path)), ...)
    }
    if (Sys.which('mimetype') == '' || mimetype(stdout = NULL) != 0)
        return(mime::guess_type(path))
    mimetype(stdout = TRUE)
}