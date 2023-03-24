procesar_datos_porcinos_valores_actuales_func <- function(raw_file_path){
  # targets::tar_read(procesar_datos_porcinos_valores_actuales) |>  colnames()
  # "precio_desc"    "valor"          "categoria_desc"
  df_ret <- tibble::tibble(precio_desc=character(0L),valor=character(0L),categoria_desc=character(0L))
  if (raw_file_path!='') {
    df_ret <- extract_capper_main_capon_data(raw_file_path)
  }
  df_ret
}
