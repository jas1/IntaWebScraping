#' extract_capper_main_capon_data
#'
#' @param rvest_html_object html file
#'
#' @return a dataframe from the sliding box on the rosgan web page : indices_tabla, valores_tabla, indices_fecha
#' @export
#'
#' @examples extract_capper_main_capon_data(dl_html_file="~/project/tmp/20221106_precios_rosgan.html")
extract_capper_main_capon_data <- function(rvest_html_object){

  downloaded_file <- rvest_html_object

  pizarra_precios_h3 <- rvest::read_html(output_dl_file) |>
    rvest::html_elements("#cpe_pizarra_de_precios-2 h3") |>
    rvest::html_text()

  precio_maximo_capon_tag <- rvest::read_html(output_dl_file) |>
    rvest::html_elements("#cpe_pizarra_de_precios-2") |>
    rvest::html_elements(".cpe-row") |>
    rvest::html_elements(".cpe-featured-name") |>
    rvest::html_text()

  precio_maximo_capon_precio <- rvest::read_html(output_dl_file) |>
    rvest::html_elements("#cpe_pizarra_de_precios-2") |>
    rvest::html_elements(".cpe-row") |>
    rvest::html_elements(".cpe-number") |>
    rvest::html_text() |>
    stringr::str_trim() |>
    readr::parse_number(locale=readr::locale("es", decimal_mark = ","))

  df_capon <- tibble::tibble(precio_desc=precio_maximo_capon_tag,valor=precio_maximo_capon_precio,categoria_desc=pizarra_precios_h3)


  df_capon

}
