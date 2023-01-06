extract_precipitaciones_table_identificar_tablas_parsear_gris_y_data_tabla <- function(p_df){

  curr_departamento <- p_df |>
    # rvest::html_table() |>
    dplyr::filter(stringr::str_detect(X1,"Dpto:")) |>
    dplyr::slice_tail(n=1) |>
    dplyr::pull(X2)

  curr_data <- p_df |>
    # rvest::html_table() |>
    dplyr::filter(stringr::str_detect(X1,"Dpto:",negate = TRUE)) |>
    dplyr::filter(stringr::str_detect(X2,"Precipitación",negate = TRUE))

  ret_data <- curr_data |>
    dplyr::mutate(departamento=curr_departamento) |>
    dplyr::rename(estacion=X1,valor=X2) |>
    dplyr::select(estacion,valor,departamento)
  ret_data
}
