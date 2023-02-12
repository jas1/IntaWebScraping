#' transformar_datos_ganaderia_valores_actuales_func
#' recibe la tabla de valores recibida de la pagina, y transforma acorde a neceario.
#' en caso de que el dataframe recibido sea vacio o que los filtros a aplicar den un dataframe vacio
#' se devuelve un dataframe con la estructura pero vacio.
#'
#' @param df_procesar_datos_ganaderia_valores_actuales df valores
#'
#' @return df transformado o df vacio
#' @export
#'
#' @examples transformar_datos_ganaderia_valores_actuales_func(df_procesar_datos_ganaderia_valores_actuales)
transformar_datos_ganaderia_valores_actuales_func <- function(df_procesar_datos_ganaderia_valores_actuales){

  ret <- data.frame(indices_tabla=character(),
                    indices_fecha=character(),
                    valores_tabla=character(),
                    explotacion=character(),
                    origen=character(),
                    actualizado_fecha=character())

  if(nrow(df_procesar_datos_ganaderia_valores_actuales)){
    tmp_df <- df_procesar_datos_ganaderia_valores_actuales |>
      dplyr::filter(stringr::str_detect(indices_tabla,"terneros/as"))

     if(nrow(df_procesar_datos_ganaderia_valores_actuales)){

      tmp_ret <- tryCatch(
        {
          ret_2 <- tmp_df |>
            dplyr::mutate(indices_fecha=parse_fecha(indices_fecha_str)) |>
            dplyr::mutate(actualizado_fecha=lubridate::today()) |>
            dplyr::mutate(explotacion="ganaderia") |>
            dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
          ret_2
        },
        error=function(cond) {
          message("Error al transformar: transformar_datos_ganaderia_valores_actuales_func")
          message("mensaje original:")
          message(cond)
          return(NA)
        }
      )
    if (length(tmp_ret)<=1) {
      print(df_procesar_datos_ganaderia_valores_actuales)
      warning("transformar_datos_ganaderia_valores_actuales_func: error al procesar'")
    }else{
      ret <- tmp_ret
    }

    }else{
      print(df_procesar_datos_ganaderia_valores_actuales[['indices_tabla']])
      warning("transformar_datos_ganaderia_valores_actuales_func: sin datos. para filtro: 'terneros/as'")
    }
  }else{
    warning("transformar_datos_ganaderia_valores_actuales_func: sin datos. df recibido vacio")
  }
  ret
}
