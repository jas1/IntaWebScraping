get_datos_recursos_porcinos_func <- function(config){
  web_page <- config[['scrap_recursos_porcinos_url']] #"https://www.rosgan.com.ar/precios-rosgan/"
  template_page_name <- config[['scrap_recursos_porcinos_dest_file_pattern']] #"{timestamp_webscrap}_precios_rosgan.html"
  output_path <- config[['scrap_raw_store_porcinos_folder']]#"tmp"
  timestamp_format <- config[['scrap_timestamp_format']] #"%Y%m%d"
  output_dl_file <- get_raw_web_file(url_src = web_page,template_output = template_page_name,output_path = output_path,timestamp_format = timestamp_format)
  output_dl_file
}
