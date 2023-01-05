#' extract_rosgan_updated_header
#'
#' @param rvest_html_object html file
#'
#' @return a dataframe from the sliding box on the rosgan web page : indices_tabla, valores_tabla, indices_fecha
#' @export
#'
#' @examples extract_rosgan_updated_header(dl_html_file="~/project/tmp/20221106_precios_rosgan.html")
extract_rosgan_updated_header <- function(rvest_html_object){

  downloaded_file <- rvest_html_object

  pre_indices_fecha <- downloaded_file |>
    rvest::html_element(".caja-titulo-verde") |>
    rvest::html_text() |>
    stringr::str_trim() |>
    stringr::str_to_lower() |>
    stringr::str_c(format(Sys.Date(), " de %Y"))

  indices_fecha_str <- pre_indices_fecha |>
    stringr::str_replace ("rosgan","") |>
    stringr::str_trim()

  origen <- dplyr::if_else(stringr::str_detect(pre_indices_fecha,"rosgan"),true = "rosgan",false="")

  indices_tabla <- downloaded_file |>
    rvest::html_elements(".caja-indice") |>
    rvest::html_elements(".indice") |>
    rvest::html_text()

  valores_tabla <- downloaded_file |>
    rvest::html_elements(".caja-indice") |>
    rvest::html_elements(".valor") |>
    rvest::html_text() |>
    readr::parse_number(locale=readr::locale("es", decimal_mark = ","))

  df_caja_verde <- tibble::tibble(indices_tabla ,valores_tabla,indices_fecha_str,origen) |>
    dplyr::mutate(indices_tabla=stringr::str_to_lower(indices_tabla))
  df_caja_verde
}
