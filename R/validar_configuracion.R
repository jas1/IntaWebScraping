validar_configuracion <- function(config){

  # --------------------------timestamp format  --------------------------------
  # scrap_timestamp_format: "%Y%m%d"
  status_validar_scrap_timestamp_format <- is.character(config[['scrap_timestamp_format']])

  # ----------------------------google sheet -----------------------------------
  # destino_recursos_url: "https://docs.google.com/spreadsheets/d/1wayzYcUboTRu3BNpfJxWQXEJ8-lcWJW0UBC9iAqE4xo/edit#gid=0"
  status_validar_destino_recursos_url <- validar_url(config[['destino_recursos_url']])

  # ---------------------------- url scrap -------------------------------------

  status_validar_scrap_recursos_ganaderia_url <- validar_url(config[['scrap_recursos_ganaderia_url']])
  status_validar_scrap_recursos_porcinos_url <- validar_url(config[['scrap_recursos_porcinos_url']])

  # ---------------------------- file crudo de scrap ---------------------------

  # scrap_recursos_ganaderia_dest_file_pattern: "{timestamp_webscrap}_precios_rosgan.html"
  status_validar_scrap_recursos_ganaderia_dest_file_pattern <- is.character(config[['scrap_recursos_ganaderia_dest_file_pattern']])
    status_validar_scrap_recursos_porcinos_dest_file_pattern  <- is.character(config[['scrap_recursos_porcinos_dest_file_pattern']])

  # ----------------------------- path store crudo scrap -----------------------
  # scrap_raw_store_ganaderia_folder: "tmp/raw/ganaderia" # VALIDAR LA CARPETA EXISTE; O CREARLO
  status_validar_scrap_raw_store_ganaderia_folder <- validar_crear_path_guardar(config[['scrap_raw_store_ganaderia_folder']])
  status_validar_scrap_raw_store_porcinos_folder  <- validar_crear_path_guardar(config[['scrap_raw_store_porcinos_folder']])


  # ----------------------------- path datos transformados ---------------------
  # datos_store_ganaderia_folder: "tmp/datos/ganaderia"
  status_validar_datos_store_ganaderia_folder <- validar_crear_path_guardar(config[['datos_store_ganaderia_folder']])
  # datos_store_tambo_folder: "tmp/datos/tambo"
  status_validar_datos_store_tambo_folder <- validar_crear_path_guardar(config[['datos_store_tambo_folder']])
  # datos_store_tambo_folder: "tmp/datos/tambo"
  status_validar_datos_store_porcinos_folder <- validar_crear_path_guardar(config[['datos_store_porcinos_folder']])

  # ------------------------------ filename datos transformados ----------------

  status_validar_datos_ganaderia_dest_file_pattern <- is.character(config[['datos_ganaderia_dest_file_pattern']])
  status_validar_datos_tambo_dest_file_pattern     <- is.character(config[['datos_tambo_dest_file_pattern']])
  status_validar_datos_porcinos_dest_file_pattern  <- is.character(config[['datos_porcinos_dest_file_pattern']])

  # ------------------------------- google sheet pagina ------------------------
  # destino_ganaderia_sheet: "ganaderia"
  status_validar_destino_ganaderia_sheet <- is.character(config[['destino_ganaderia_sheet']])
  # destino_ganaderia_sheet: "tambo"
  status_validar_destino_tambo_sheet <- is.character(config[['destino_tambo_sheet']])
  # destino_porcinos_sheet: "porcinos"
  status_validar_destino_porcinos_sheet<- is.character(config[['destino_porcinos_sheet']])

  # ------------------------------- lista variables out ------------------------

  validation_list <- c(status_validar_scrap_timestamp_format,
                       status_validar_destino_recursos_url,
                       status_validar_scrap_recursos_ganaderia_url,
                       status_validar_scrap_recursos_porcinos_url,
                       status_validar_scrap_recursos_ganaderia_dest_file_pattern,
                       status_validar_scrap_recursos_porcinos_dest_file_pattern,
                       status_validar_scrap_raw_store_ganaderia_folder,
                       status_validar_scrap_raw_store_porcinos_folder,
                       status_validar_datos_store_ganaderia_folder,
                       status_validar_datos_store_tambo_folder,
                       status_validar_datos_store_porcinos_folder,
                       status_validar_datos_ganaderia_dest_file_pattern,
                       status_validar_datos_tambo_dest_file_pattern,
                       status_validar_datos_porcinos_dest_file_pattern,
                       status_validar_destino_ganaderia_sheet,
                       status_validar_destino_tambo_sheet,
                       status_validar_destino_porcinos_sheet)

  print(validation_list)
  stopifnot(all(validation_list))

  config

}


