#' extract_rosgan_updated_header
#'
#' @param rvest_html_object html file
#'
#' @return a dataframe from the sliding box on the rosgan web page : indices_tabla, valores_tabla, indices_fecha
#' @export
#'
#' @examples extract_rosgan_updated_header(dl_html_file="~/project/tmp/20221106_precios_rosgan.html")
extract_rosgan_updated_header <- function(raw_file_path){

  downloaded_file <- rvest::read_html(raw_file_path)

  # ya no dice mas esto. la fecha le voy a poner el dia de scrap.
  # pre_indices_fecha <- downloaded_file |>
  #   rvest::html_element(".caja-titulo-verde") |>
  #   rvest::html_text() |>
  #   stringr::str_trim() |>
  #   stringr::str_to_lower() |>
  #   stringr::str_c(format(Sys.Date(), " de %Y"))

  # ya no levant amas la fecha
  # se puede martillar de una, o para que no rompa el resto del proceso ponerle lo que esperaba
  # algo como: 14 de diciembre de 2023
  # esto lo devuelve segun locale, asi que le puse EN o ES, si hay otros toca cambiar en R/get_mes_segun_fecha.R
  indices_fecha_str <- format(Sys.Date(), "%d de %B de %Y")

  # esto cambio dice "habitual 190" ya no menciona fecha ni rosgan.
  # se camboa ppr analizar el titulo
  header_title <- downloaded_file |>
    rvest::html_element("title") |>
    rvest::html_text() |>
    stringr::str_to_lower()

  origen <- dplyr::if_else(stringr::str_detect(header_title,"rosgan"),true = "rosgan",false="")

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
