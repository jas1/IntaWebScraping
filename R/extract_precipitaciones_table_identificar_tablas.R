extract_precipitaciones_table_identificar_tablas <- function(x){
  current_df <- x |> rvest::html_table()
  es_df_total <- current_df |>
    dplyr::slice_head(n=1) |>
    dplyr::filter(stringr::str_detect(X1,"Precipitaciones Históricas de la Red Pluviométrica Provincia")) |> nrow()

  current_msg <- "es data"

  if (es_df_total) {
    current_msg <- "es header"
    current_df <- data.frame()
  }
  # es un df de 1 row y 2 cols.
  es_df_gris <- all(current_df |>  dim() ==c(1,2))

  if (es_df_gris) {
    current_msg <- "es gris"
    current_df <- data.frame()
  }

  if (nrow(current_df) > 0 ) {
    current_msg <- "es data"
    current_df <- extract_precipitaciones_table_identificar_tablas_parsear_gris_y_data_tabla(current_df)
  }
  #print(current_msg)
  current_df
}
