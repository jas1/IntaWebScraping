almacenar_datos_ganaderia_valores_actuales_func <- function(transformacion_df,config){
  # determinar forma de guardar, puede ser un archivo temporal. luego en el siguiente paso se disponibliza ese resultado en por ejemplo google sheets u otro lado


  timestamp_datos <- format(Sys.time(), config[['scrap_timestamp_format']])
  page_name <- glue::glue(config[['datos_ganaderia_dest_file_pattern']])
  output_file_path <- here::here(config[['datos_store_ganaderia_folder']],page_name)

  if ( !file.exists(output_file_path)) {
    readr::write_tsv(x = transformacion_df,file = output_file_path)
  }else{
    print(glue::glue("almacenar_datos_ganaderia_valores_actuales_func: archivo reemplazado : {output_file_path}") )
    readr::write_tsv(x = transformacion_df,file = output_file_path)
  }

  output_file_path
}
