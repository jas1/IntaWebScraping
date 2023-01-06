get_deptos_distritos_map <- function(config){

  auth_google_sheets(config)

  resultado_sheet <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                               sheet = config[['origen_dptos_distritos_map']])

  resultado_sheet
}
