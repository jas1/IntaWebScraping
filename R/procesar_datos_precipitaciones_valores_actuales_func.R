procesar_datos_precipitaciones_valores_actuales_func <- function(raw_file_path){
  # targets::tar_read(procesar_datos_precipitaciones_valores_actuales) |>  colnames()
  # "estacion"          "valor"             "departamento"      "descripcion_fecha"
  df_ret <- tibble::tibble(estacion=character(0L),valor=character(0L),departamento=character(0L),descripcion_fecha=character(0L))
  if (raw_file_path!='') {
    df_ret <- extract_precipitaciones_table(raw_file_path)
  }
  df_ret
}
