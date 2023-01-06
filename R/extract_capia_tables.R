#' extract_capia_tables
#'
#' @param dl_html_file downloaded html file
#'
#' @return dataframe con los datos de capia del ultimo html, generalmente varias semanas para atras tiene.
#' @export
#'
#' @examples extract_capia_tables(rvest_html_object=rvest::html("~/project/tmp/capia.html"))
extract_capia_tables <- function(rvest_html_object){

  #downloaded_file <- rvest::read_html(dl_html_file)
  downloaded_file <- rvest_html_object

  obtener_tablas <- html_loaded|>
    # rvest::html_elements("#sp-main-body")
    rvest::html_elements(".post_intro table") |>
    rvest::html_table() |>
    purrr::map_dfr(.f=function(df_x){
      ref_semana <- df_x |>
        dplyr::filter(stringr::str_detect(stringr::str_to_upper(X1),"REFERENCIA SEMANA")) |>
        dplyr::pull(X1)

      ref_huevo <- df_x |>
        dplyr::filter(stringr::str_detect(stringr::str_to_lower(X1),"polla recriada de 16 semanas blanca")) |>
        dplyr::mutate(descripcion=paste0(X1," - " ,X2))|>
        dplyr::rename(precio=X3) |>
        dplyr::select(descripcion,precio) |>
        dplyr::mutate(fecha_semana=ref_semana)

      ref_carne_ave <- df_x |>
        dplyr::filter(stringr::str_detect(stringr::str_to_lower(X1),"polla recriada de 18 semanas blanca")) |>
        dplyr::mutate(descripcion=paste0(X1," - " ,X2))|>
        dplyr::rename(precio=X3) |>
        dplyr::select(descripcion,precio)|>
        dplyr::mutate(fecha_semana=ref_semana)

      resu <- ref_huevo |> dplyr::union(ref_carne_ave)
      resu
    })

  obtener_tablas
}
