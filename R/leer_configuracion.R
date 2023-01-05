leer_configuracion <- function(default_path="config/config.yml"){
  config <- config::get(file = here::here(default_path), use_parent = FALSE)
  config
}

