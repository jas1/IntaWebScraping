transformar_datos_ganaderia_valores_actuales_func <- function(df_procesar_datos_ganaderia_valores_actuales){
# TODO: AGREGAR LAS TRANSFORMACIONES NECEASRIAS, DETERMINAR FORMATO DE INTERES. creo que seria ganaderia,precio,fecha
  # ganaderia,precio,fechaa transformar_datos_ganaderia_valores_actuales_func
  ret <- df_procesar_datos_ganaderia_valores_actuales |>
    dplyr::filter(stringr::str_detect(indices_tabla,"terneros/as")) |>
    dplyr::mutate(indices_fecha=parse_fecha(indices_fecha_str)) |>
    dplyr::mutate(actualizado_fecha=lubridate::today()) |>
    dplyr::mutate(explotacion="ganaderia") |>
    dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
  ret
}
