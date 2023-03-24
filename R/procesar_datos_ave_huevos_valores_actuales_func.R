procesar_datos_ave_huevos_valores_actuales_func <- function(raw_file_path){
  # targets::tar_read(procesar_datos_ave_huevos_valores_actuales) |>  colnames()
  # "estacion"          "valor"             "departamento"      "descripcion_fecha"
  df_ret <- tibble::tibble(descripcion=character(0L),precio=character(0L),fecha_semana=character(0L))

  if (raw_file_path!='') {
    df_ret <- extract_capia_tables(raw_file_path)
  }
  df_ret
}
