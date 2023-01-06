validar_disponible_datos_carne_ave_valores_actuales_func <- function(almacenar_datos_valores, disponibilizar_datos_resultado,config){

  # verificar que lo almacenado es igual a lo disponible.
  resultado_file_almacenar <- readr::read_tsv(almacenar_datos_valores)
  auth_google_sheets(config)

  resultado_sheet <- googlesheets4::read_sheet(ss = disponibilizar_datos_resultado[['url']],
                                               sheet = disponibilizar_datos_resultado[['sheet']])


  resu_join <- resultado_file_almacenar |> dplyr::anti_join(resultado_sheet,by=c("indices_tabla","indices_fecha","actualizado_fecha"))

  valido <- nrow(resu_join)==0
  ret <- list("status"=valido,
              "almacenar_df"=resultado_file_almacenar,
              "sheet_df"=resultado_sheet)
  ret
}
