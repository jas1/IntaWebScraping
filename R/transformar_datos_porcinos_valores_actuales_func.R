transformar_datos_porcinos_valores_actuales_func <- function(df_crudo_extraido){
  # para porcinos viene  bien diferente el df
  #precio_desc , valor, categoria_desc
  #df_crudo_extraido <-  porcesados_datos
  ret <- df_crudo_extraido |>
    dplyr::filter(stringr::str_detect(precio_desc,"Máximo")) |>
    dplyr::mutate(indices_tabla=glue::glue("{categoria_desc} - {precio_desc}")) |>
    dplyr::mutate(indices_fecha=lubridate::today()) |>
    dplyr::mutate(actualizado_fecha=lubridate::today()) |>
    dplyr::rename(valores_tabla=valor) |>
    dplyr::mutate(explotacion="porcinos") |>
    dplyr::mutate(origen="capper") |>
    dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
  ret
}
