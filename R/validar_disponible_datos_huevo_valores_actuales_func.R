#' validar_disponible_datos_huevo_valores_actuales_func
#'
#' compara lo a cargar VS lo cargado para ver si esta valido o no.
#' si almacenar datos viene vacio entonces salta y devuelve vacio.
#'
#' @param almacenar_datos_valores valor a cargar
#' @param disponibilizar_datos_resultado  valor cargado
#' @param config configuracion
#'
#' @return lista : status,almacenar,sheet ; o vacio
#' @export
#'
#' @examples validar_disponible_datos_huevo_valores_actuales_func(almacenar_datos_valores, disponibilizar_datos_resultado,config)
validar_disponible_datos_huevo_valores_actuales_func <- function(almacenar_datos_valores, disponibilizar_datos_resultado,config){

  ret <- ''
  if (almacenar_datos_valores != '') {

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
  }else{
    warning("validar_disponible_datos_huevo_valores_actuales_func: para actualziar huevo")
  }
  ret
}
