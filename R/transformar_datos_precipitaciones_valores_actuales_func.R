transformar_datos_precipitaciones_valores_actuales_func <- function(df_procesado,df_mapping){
  # devuelve: df: estacion,valor,departamento,descripcion_fecha
  # df:row:"Arroyo Barú,0 mm,Colón,Precipitaciones registradas hasta las 09:00hs del día 05/01/2023 (24 horas)"

  ret <- df_procesado |>
    dplyr::mutate(indices_tabla=glue::glue("{estacion} | {valor} | {departamento} | {descripcion_fecha}")) |>
    dplyr::mutate(indices_fecha=lubridate::dmy(stringr::str_sub(start=50,end=65,descripcion_fecha))) |>
    dplyr::mutate(actualizado_fecha=lubridate::today()) |>
    dplyr::mutate(valores_tabla=readr::parse_number(valor,locale = readr::locale(decimal_mark = ","))) |>
    dplyr::mutate(variable="precipitacion") |>
    dplyr::mutate(origen="hidraulica") |>
    dplyr::select(indices_tabla,estacion,departamento,indices_fecha,valores_tabla,variable,origen,actualizado_fecha) |>
    dplyr::left_join(df_mapping,by=c("departamento","estacion"))
  ret
}
