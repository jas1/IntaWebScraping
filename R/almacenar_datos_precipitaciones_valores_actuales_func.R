almacenar_datos_precipitaciones_valores_actuales_func <- function(datos_transformados,config){
  # determinar forma de guardar, puede ser un archivo temporal. luego en el siguiente paso se disponibliza ese resultado en por ejemplo google sheets u otro lado

  timestamp_datos <- format(Sys.time(), config[['scrap_timestamp_format']])
  page_name <- glue::glue(config[['datos_precipitaciones_dest_file_pattern']])
  output_file_path <- here::here(config[['datos_store_precipitaciones_folder']],page_name)

  if ( !file.exists(output_file_path)) {
    readr::write_tsv(x = datos_transformados,file = output_file_path)
  }else{
    print(glue::glue("almacenar_datos_precipitaciones_valores_actuales_func: archivo reemplazado : {output_file_path}") )
    readr::write_tsv(x = datos_transformados,file = output_file_path)
  }

  output_file_path
}
