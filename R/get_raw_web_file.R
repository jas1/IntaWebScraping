#' get_raw_web_file
#'
#' @param url_src url source
#' @param template_output template file name output: '{timestamp_webscrap}_precios_rosgan.html'
#' @param output_path folder where the result downloaded file will be stored, example tmp, but relative to proyect: here::here(tmp) ,
#' @param timestamp_format string date format, example: "%Y%m%d"
#'
#' @return the path of the stored output file
#' @export
#'
#' @examples get_raw_web_file(url_src = "https://www.rosgan.com.ar/precios-rosgan/",template_output = "{timestamp_webscrap}_precios_rosgan.html",output_path = "tmp",timestamp_format = "%Y%m%d")
get_raw_web_file <- function(url_src,template_output,output_path,timestamp_format="%Y%m%d"){


  timestamp_webscrap <- format(Sys.time(), timestamp_format)
  page_name <- glue::glue(template_output)
  output_file_path <- here::here(output_path,page_name)

  if( !dir.exists(here::here(output_path)) ){
    dir.create(here::here(output_path))
  }

  if ( !file.exists(output_file_path)) {
    download.file(url = url_src,destfile = output_file_path)
  }
  output_file_path
}
