get_datos_precipitaciones_func <- function(config,url_valida){
  output_dl_file <- ''
  web_page <- config[['scrap_precipitaciones_url']]
  if(url_valida){
    template_page_name <- config[['scrap_precipitaciones_dest_file_pattern']]
    output_path <- config[['scrap_raw_store_precipitaciones_folder']]#"tmp"
    timestamp_format <- config[['scrap_timestamp_format']] #"%Y%m%d"
    output_dl_file <- get_raw_web_file(url_src = web_page,template_output = template_page_name,output_path = output_path,timestamp_format = timestamp_format)
  }else{
    warning(glue::glue("url no valida. url_valida: {url_valida}. web: {web_page} "))
  }
  output_dl_file
}
