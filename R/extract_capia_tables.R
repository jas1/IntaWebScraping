#' extract_capia_tables
#'
#' @param dl_html_file downloaded html file
#'
#' @return dataframe con los datos de capia del ultimo html, generalmente varias semanas para atras tiene.
#' @export
#'
#' @examples extract_capia_tables(rvest_html_object=rvest::html("~/project/tmp/capia.html"))
extract_capia_tables <- function(dl_html_file){

  downloaded_file <- rvest::read_html(dl_html_file)

  #  para obtener bien los titulos de fechas publicadas: #
  tmp_posts_titulos <- downloaded_file |> rvest::html_elements(".post_intro h2 a") |> rvest::html_text() |> stringr::str_trim()
# tmp_x <- downloaded_file |> rvest::html_elements(".post_intro")
  posts <- downloaded_file |> rvest::html_elements(".post_intro") |>  # cantidad de posts
  purrr::map(.f=function(x){
    # x <- tmp_x[[2]]
     extraer_titulos <- x |> rvest::html_elements("h2 a") |> rvest::html_text() |> stringr::str_trim()

    extraer_tablas <- x |> rvest::html_elements("table") |> rvest::html_table()
    if(length(extraer_tablas)!=1){
      warning(glue::glue("PROBABLE ERROR EN DATOS DE TABLA: extract_capia_tables, tabla != de 1.\n
              REVISAR pagina de capia para el post de fecha: '{extraer_titulos}', poniendo tabla vacia.\n
              Cargar datos tablas 'carne_ave' y 'huevos' MANUALMENTE."))
      extraer_tablas <- list( tibble::tibble(X1=character(),X2=character(),X3=character(),X4=character(),X5=character()) )
    }

    tibble::tibble(titulo=extraer_titulos,tabla=extraer_tablas)
  }) |>
    purrr::reduce(dplyr::union)
  # tema de tablas: ej el 06/02: publicaron un print screen de un excel !
  # si cantidad de tablas != cantidad de posts => seguro publicaron algo diferente de tabla.
  # en ese caso van a tener que cargarlo a mano.

  tablas_procesadas <- posts |>
    dplyr::mutate(procesadas = purrr::map2(.x=tabla,.y = titulo,.f=function(df_x,titulo_x){
      # idx_x <- 1
      # titulo_x <- posts$titulo[[idx_x]]
      # df_x <- posts$tabla[[idx_x]]
      ref_semana <- df_x |>
        dplyr::filter(stringr::str_detect(stringr::str_to_upper(X1),"REFERENCIA SEMANA")) |>
        dplyr::pull(X1)
      if (nrow(df_x)==0) {
        warning(glue::glue("PROBABLE ERROR EN DATOS DE TABLA: extract_capia_tables, tabla vacia. \n
              REVISAR pagina de CAPIA para el post de fecha: '{titulo_x}', utilizando el titulo del post en vez de referencia semana.
               Cargar datos tablas 'carne_ave' y 'huevos' MANUALMENTE. \n
              "))
        ref_semana <- titulo_x
      }else{
        if (length(ref_semana)!=1) {
          warning(glue::glue("PROBABLE ERROR EN DATOS DE TABLA: extract_capia_tables, fila: 'REFERENCIA SEMANA' != de 1. \n
              REVISAR pagina de CAPIA para el post de fecha: '{titulo_x}', utilizando el titulo del post en vez de referencia semana.
              REVISAR carga de datos tabla carne_ave y huevos. Probable necesidad de corrección de forma manual. \n
              "))
          ref_semana <- titulo_x
        }
      }


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
    }))
  resultado <- tablas_procesadas |> dplyr::select(procesadas)|> tidyr::unnest(procesadas)

  resultado
}
