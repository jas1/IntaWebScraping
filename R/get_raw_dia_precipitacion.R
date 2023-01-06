# para enviar via post , la variable "selected fecha " que tiene la pagina para obtener de un dia especifico.

get_raw_dia_precipitacion <- function(url_src,
                                      fecha_yyyy_mm_dd="2023-01-01",
                                      template_output,
                                      output_path,
                                      timestamp_format="%Y%m%d",
                                      lote_dl="dia"){

  timestamp_webscrap <- format(Sys.time(), timestamp_format)
  page_name <- glue::glue(template_output)
  output_file_path <- here::here(output_path,page_name)

  if( !dir.exists(here::here(output_path)) ){
    dir.create(here::here(output_path))
  }

  if ( !file.exists(output_file_path)) {
    # download.file(url = url_src,destfile = output_file_path)
    response_res <- httr::POST(url_src,
                               body = list(selectedFecha = fecha_yyyy_mm_dd),
                               encode = "form", httr::write_disk(path = output_file_path,overwrite = TRUE))
  }
  #response_res$status_code==200

  output_file_path
}
