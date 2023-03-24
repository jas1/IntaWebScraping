procesar_datos_ganaderia_valores_actuales_func <- function(raw_file_path){
  # targets::tar_read(procesar_datos_ganaderia_valores_actuales) |>  colnames()
  # "indices_tabla"     "valores_tabla"     "indices_fecha_str" "origen"
  df_ret <- tibble::tibble(indices_tabla=character(0L),valores_tabla=character(0L),indices_fecha_str=character(0L),origen=character(0L))
  if (raw_file_path!='') {
    df_ret <- extract_rosgan_updated_header(raw_file_path)
  }
  df_ret
}
