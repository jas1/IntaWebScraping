#' transformar_datos_porcinos_valores_actuales_func
#' recibe df extraido del crudo, valida si vacio ,
#' devuelve df transformado o df vacio ( 0 rows )
#' levanta warnings en caso de vacio.
#'
#' @param df_crudo_extraido df a transformar
#'
#' @return df transformado o df vacio
#' @export
#'
#' @examples transformar_datos_porcinos_valores_actuales_func (df_crudo_extraido)
transformar_datos_porcinos_valores_actuales_func <- function(df_crudo_extraido){

  ret <- data.frame(indices_tabla=character(),
                    indices_fecha=character(),
                    valores_tabla=character(),
                    explotacion=character(),
                    origen=character(),
                    actualizado_fecha=character())

  if(nrow(df_crudo_extraido)>0){
    df_ret <- df_crudo_extraido |>
      dplyr::filter(stringr::str_detect(precio_desc,"Máximo"))

    if (nrow(df_ret) > 0) {
        ret <- df_ret |>
          dplyr::mutate(indices_tabla=glue::glue("{categoria_desc} - {precio_desc}")) |>
          dplyr::mutate(indices_fecha=lubridate::today()) |>
          dplyr::mutate(actualizado_fecha=lubridate::today()) |>
          dplyr::rename(valores_tabla=valor) |>
          dplyr::mutate(explotacion="porcinos") |>
          dplyr::mutate(origen="capper") |>
          dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
    }else{
      print(df_crudo_extraido[['precio_desc']])
      warning("transformar_datos_porcinos_valores_actuales_func: sin datos. para filtro: precio_desc=='Máximo'")
    }
  }else{
    warning("transformar_datos_porcinos_valores_actuales_func: sin datos. df recibido vacio")
  }
  ret
}
