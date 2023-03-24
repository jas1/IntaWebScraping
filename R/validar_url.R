validar_url <- function(url_in,t=2){
  # sacado de: https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  ret <- ifelse(is.null(check),TRUE,FALSE)

  if (!ret) {
    warning(glue::glue("WEBSCRAP: PAGINA NO ENCONTRADA: {url_in}"))
  }
  ret
}
