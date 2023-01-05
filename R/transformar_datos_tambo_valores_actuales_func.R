transformar_datos_tambo_valores_actuales_func <- function(df_procesar_datos_ganaderia_valores_actuales){
  # tambo sale del mismo origen que ganaderia, solo filtramos por otro string
  ret <- df_procesar_datos_ganaderia_valores_actuales |>
    dplyr::filter(stringr::str_detect(indices_tabla,"vacas c/gtía. de preñez")) |>
    dplyr::mutate(indices_fecha=parse_fecha(indices_fecha_str)) |>
    dplyr::mutate(actualizado_fecha=lubridate::today()) |>
    dplyr::mutate(explotacion="tambo") |>
    dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
  ret
}
