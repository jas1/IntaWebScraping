#' transformar_datos_carne_ave_valores_actuales_func
#' recibe df extraido del crudo, valida si vacio ,
#' devuelve df transformado o df vacio ( 0 rows )
#' levanta warnings en caso de vacio.
#'
#' @param df_procesado df a transformar
#'
#' @return df transformado o df vacio
#' @export
#'
#' @examples transformar_datos_carne_ave_valores_actuales_func (df_procesado)
transformar_datos_carne_ave_valores_actuales_func <- function(df_procesado){
  # tambo sale del ave / huevo: formato df:
  # "descripcion"  "precio"       "fecha_semana"
  # Polla recriada de 16 semanas blanca - C/U	$ 997,50	REFERENCIA SEMANA DEL 02/01/2023
  # Polla recriada de 18 semanas blanca - C/U	$ 1.050,00	REFERENCIA SEMANA DEL 02/01/2023

  # descripcion=="Polla recriada de 16 semanas blanca" > explotacion=="huevo"
  # descripcion=="Polla recriada de 18 semanas blanca" > explotacion=="carne_ave"

  ret <- data.frame(indices_tabla=character(),
                    indices_fecha=character(),
                    valores_tabla=character(),
                    explotacion=character(),
                    origen=character(),
                    actualizado_fecha=character())

  if(nrow(df_procesado)>0){
    df_ret <- df_procesado |>
      dplyr::filter(stringr::str_detect(stringr::str_to_lower(descripcion),"polla recriada de 18 semanas blanca"))

      if (nrow(df_ret) > 0) {
        ret <- df_ret |>
          dplyr::mutate(indices_tabla=glue::glue("{descripcion} | {precio} | {fecha_semana}")) |>
          dplyr::mutate(indices_fecha=lubridate::dmy(fecha_semana)) |>
          dplyr::mutate(actualizado_fecha=lubridate::today()) |>
          dplyr::mutate(valores_tabla=readr::parse_number(precio,locale = readr::locale(decimal_mark = ","))) |>
          dplyr::mutate(explotacion="carne_ave") |>
          dplyr::mutate(origen="capia") |>
          dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
      }else{
        print(df_procesado[['descripcion']])
        warning("transformar_datos_carne_ave_valores_actuales_func: sin datos. para filtro: descripcion=='polla recriada de 18 semanas blanca'")
      }
  }else{
    warning("transformar_datos_carne_ave_valores_actuales_func: sin datos. df recibido vacio")
  }
  ret
}
