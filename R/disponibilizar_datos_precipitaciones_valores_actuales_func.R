disponibilizar_datos_precipitaciones_valores_actuales_func <- function(path_almacenado,config){
  # Authenticate using token. If no browser opens, the authentication works.

  auth_google_sheets(config)

  tmp_df <- readr::read_tsv(path_almacenado)

  googlesheets4::write_sheet(data = tmp_df,ss =  config[['destino_recursos_url']],sheet = config[['destino_precipitaciones_sheet']])

  ret <- list("url"=config[['destino_recursos_url']],
              "sheet"=config[['destino_precipitaciones_sheet']])
  ret
}
