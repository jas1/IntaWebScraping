#' almacenar_datos_tambo_valores_actuales_func
#'  devuelve el path del df transforamdo , o vacio en caso de que el DF no tenga valores.
#'  puede suceder si no hay datos en el fitro de scrapping para una fecha.
#'
#' @param transformacion_df transformacion realizada
#' @param config configuracion
#'
#' @return path de archivo o vacio.
#' @export
#'
#' @examples almacenar_datos_tambo_valores_actuales_func(datos_transformados,config)
almacenar_datos_tambo_valores_actuales_func <- function(transformacion_df,config){
  # determinar forma de guardar, puede ser un archivo temporal. luego en el siguiente paso se disponibliza ese resultado en por ejemplo google sheets u otro lado

  output_file_path <- ""

  if (nrow(transformacion_df)>0) {

    timestamp_datos <- format(Sys.time(), config[['scrap_timestamp_format']])
    page_name <- glue::glue(config[['datos_tambo_dest_file_pattern']])
    output_file_path <- here::here(config[['datos_store_tambo_folder']],page_name)

    if ( !file.exists(output_file_path)) {
      readr::write_tsv(x = transformacion_df,file = output_file_path)
    }else{
      print(glue::glue("almacenar_datos_tambo_valores_actuales_func: archivo reemplazado : {output_file_path}") )
      readr::write_tsv(x = transformacion_df,file = output_file_path)
    }
  }else{
    print(glue::glue("almacenar_datos_tambo_valores_actuales_func: no hay datos de tambo") )

  }



  output_file_path
}
