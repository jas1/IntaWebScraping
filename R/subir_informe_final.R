# https://drive.google.com/drive/folders/1iTe9591gswZdkfsIAOkUGhuOFvv-IFRQ


#' subir_informe_final
#'
#' agarra el path qmd, se fija que se haya generado el .html,
#' si esta, lo sube al drive segun config.
#' si no esta devuelve arroja warning y devuelve ""
#'
#' @param config config
#'
#' @return lista: url,origen, o ""
#' @export
#'
#' @examples subir_informe_final("reportes/reporte.qmd",config)
subir_informe_final <- function(config){

  tmp_path <- here::here(stringr::str_replace(config[['informe_final_path']] ,".qmd",".html") )
  ret <- ""
  if (file.exists(tmp_path)) {
    options(gargle_quiet = FALSE)
    options(
      gargle_oauth_email = TRUE,
      gargle_oauth_cache = config[["destino_drive_cfg_path"]]
    )
    googledrive::drive_deauth()
    # googledrive::drive_auth(cache = config[["destino_drive_cfg_path"]], email = config[["destino_auth_mail"]])
    googledrive::drive_auth(cache = config[["destino_drive_cfg_path"]])


    googledrive::drive_put(media = tmp_path,
                           path = config[['destino_informes_url']])

    ret <- list("url"=config[['destino_informes_url']],
                "origen"=tmp_path)

  }else{
    warning("subir_informe_final: sin informe.")

  }
  ret
}

