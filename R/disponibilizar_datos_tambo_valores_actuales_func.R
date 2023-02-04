#' disponibilizar_datos_tambo_valores_actuales_func
#' si path distinto de vacio, entonces escribe los valores a la configuracion.
#' path puede venir vacio porque no hay datos para el momento de scrap.
#'
#' @param path_almacenado path almacenado puede ser un path o ''
#' @param config config
#'
#' @return list: url / sheet, o ''
#' @export
#'
#' @examples disponibilizar_datos_tambo_valores_actuales_func(path_almacenado,config)
disponibilizar_datos_tambo_valores_actuales_func <- function(path_almacenado,config){
  # Authenticate using token. If no browser opens, the authentication works.
  ret <- path_almacenado
  if (path_almacenado!='') {
    auth_google_sheets(config)

    tmp_df <- readr::read_tsv(path_almacenado)

    googlesheets4::write_sheet(data = tmp_df,ss =  config[['destino_recursos_url']],sheet = config[['destino_tambo_sheet']])

    ret <- list("url"=config[['destino_recursos_url']],
                "sheet"=config[['destino_tambo_sheet']])
    ret
  }else{
    warning("disponibilizar_datos_tambo_valores_actuales_func: sin datos.")
  }
  ret
}
