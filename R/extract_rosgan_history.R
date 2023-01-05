#' extract_rosgan_history
#'
#' @param dl_html_file downloaded html file
#'
#' @return a dataframe from the history values on the rosgan web page : categorias_remates, valores_categorias_remates, valores_categorias_remates, nombres_remates
#' @export
#'
#' @examples extract_rosgan_history(dl_html_file="~/project/tmp/20221106_precios_rosgan.html")
extract_rosgan_history <- function(dl_html_file){

  downloaded_file <- rvest::read_html(dl_html_file)


  nombres_remates <- downloaded_file |>
    rvest::html_elements(".remate dt") |>
    rvest::html_text()

  categorias_remates <- downloaded_file |>
    rvest::html_elements(".categoria dt") |>
    rvest::html_text()

  valores_categorias_remates <- downloaded_file |>
    rvest::html_elements(".categoria dd") |>
    rvest::html_text() |>
    readr::parse_number()# en este caso es . el decimal locale=readr::locale("es", decimal_mark = ".")


  nombres_remates_df <- tibble::tibble(nombres_remates) |> tibble::rownames_to_column("nuevo_ciclo_idx")
  remates_history <- tibble::tibble(categorias_remates,valores_categorias_remates) |>
    dplyr::mutate(nuevo_ciclo=dplyr::if_else(categorias_remates=="Terneros",1,0)) |>
    dplyr::mutate(nuevo_ciclo_idx=as.character(cumsum(nuevo_ciclo)) ) |>
    dplyr::left_join(nombres_remates_df,by="nuevo_ciclo_idx") |>
    dplyr::select(-nuevo_ciclo,-nuevo_ciclo_idx)

  remates_history
}
