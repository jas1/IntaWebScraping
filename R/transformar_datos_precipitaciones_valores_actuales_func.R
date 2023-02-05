#' transformar_datos_precipitaciones_valores_actuales_func
#' recibe la tabla de valores recibida de la pagina, y el mapeo estacion/distrito
#' transforma acorde a necesario.
#' en caso de que el dataframe recibido sea vacio o que los filtros a aplicar den un dataframe vacio
#' se devuelve un dataframe con la estructura pero vacio.
#'
#' @param df_procesado df procesado de precipitaciones
#' @param df_mapping mapeo departamento,estacion,distrito
#'
#' @return df transformado o df vacio
#' @export
#'
#' @examples transformar_datos_precipitaciones_valores_actuales_func(df_procesado,df_mapping)
transformar_datos_precipitaciones_valores_actuales_func <- function(df_procesado,df_mapping){
  # devuelve: df: estacion,valor,departamento,descripcion_fecha
  # df:row:"Arroyo Barú,0 mm,Colón,Precipitaciones registradas hasta las 09:00hs del día 05/01/2023 (24 horas)"

  ret <- data.frame(indices_tabla=character(),
                    estacion=character(),
                    departamento=character(),
                    depto_codigo=character(),
                    indices_fecha=character(),
                    valores_tabla=character(),
                    variable=character(),
                    origen=character(),
                    actualizado_fecha=character(),
                    distrito=character())

  if(nrow(df_procesado)>0){
    ret <- df_procesado |>
      dplyr::mutate(indices_tabla=glue::glue("{estacion} | {valor} | {departamento} | {descripcion_fecha}")) |>
      dplyr::mutate(indices_fecha=lubridate::dmy(stringr::str_sub(start=50,end=65,descripcion_fecha))) |>
      dplyr::mutate(actualizado_fecha=lubridate::today()) |>
      dplyr::mutate(valores_tabla=readr::parse_number(valor,locale = readr::locale(decimal_mark = ","))) |>
      dplyr::mutate(depto_codigo=janitor::make_clean_names(departamento,allow_dupes=TRUE)) |>
      dplyr::mutate(variable="precipitacion") |>
      dplyr::mutate(origen="hidraulica") |>
      dplyr::select(indices_tabla,estacion,departamento,depto_codigo,indices_fecha,valores_tabla,variable,origen,actualizado_fecha) |>
      dplyr::left_join(df_mapping,by=c("departamento","estacion"))
  }else{
    warning("transformar_datos_precipitaciones_valores_actuales_func: sin datos. df recibido vacio")
  }
  ret

}
