
auth_google_sheets <- function(config) {
  googlesheets4::gs4_auth(cache = config[['destino_cfg_path']], email = config[['destino_auth_mail']])
}

