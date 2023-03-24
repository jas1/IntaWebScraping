get_deptos_distritos_map <- function(config,url_valida){
  # departamento	estacion	distrito	distrito_app
  df_ret <- tibble::tibble(departamento=character(0L),estacion=character(0L),distrito=character(0L),distrito_app=character(0L))
  if (url_valida) {
    auth_google_sheets(config)
    df_ret <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                                 sheet = config[['origen_dptos_distritos_map']])
    df_ret
  }
  df_ret
}
