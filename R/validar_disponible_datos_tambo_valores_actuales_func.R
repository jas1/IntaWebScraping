validar_disponible_datos_tambo_valores_actuales_func <- function(almacenar_datos_valores, disponibilizar_datos_resultado,config){

  # verificar que lo almacenado es igual a lo disponible.
  resultado_file_almacenar <- readr::read_tsv(almacenar_datos_valores)
  auth_google_sheets(config)

  resultado_sheet <- googlesheets4::read_sheet(ss = disponibilizar_datos_resultado[['url']],
                                               sheet = disponibilizar_datos_resultado[['sheet']])

  tmp1 <-  purrr::map_chr(resultado_file_almacenar['indices_fecha'],
             tmp_format=config[["scrap_timestamp_format"]],
             .f = function(x,tmp_format){format(x,tmp_format )})
  tmp2 <-  purrr::map_chr(resultado_sheet['indices_fecha'],
                      tmp_format=config[["scrap_timestamp_format"]],
                      .f = function(x,tmp_format){format(x,tmp_format )})


  r1 <- all(resultado_file_almacenar['indices_tabla']==resultado_sheet['indices_tabla'])
  r2 <- all(resultado_file_almacenar['valores_tabla']==resultado_sheet['valores_tabla'])
  r3 <- all(resultado_file_almacenar['explotacion']==resultado_sheet['explotacion'])
  r4 <- all(resultado_file_almacenar['origen']==resultado_sheet['origen'])
  r5 <- all(tmp1==tmp2)
  resu_comp <- c(r1,r2,r3,r4,r5)
  valido <- all(resu_comp)
  ret <- list("status"=valido,
              "almacenar_df"=resultado_file_almacenar,
              "sheet_df"=resultado_sheet)
  ret
}
