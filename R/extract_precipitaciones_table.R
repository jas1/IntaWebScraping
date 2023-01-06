extract_precipitaciones_table <- function(rvest_html_object){
  # devuelve: df: estacion,valor,departamento,descripcion_fecha
  # df:row:"Arroyo Barú,0 mm,Colón,Precipitaciones registradas hasta las 09:00hs del día 05/01/2023 (24 horas)"
  pp_tables <- rvest_html_object |> rvest::html_elements("table")
  descripcion_fecha <- pp_tables[[2]] |>
    rvest::html_table() |>
    dplyr::filter(stringr::str_detect(X1,"Precipitaciones registradas hasta")) |>
    dplyr::pull(X1)

  tablas_df <- pp_tables  |>
    purrr::map_df(.f=extract_precipitaciones_table_identificar_tablas) |>
    dplyr::mutate(descripcion_fecha=descripcion_fecha)
  tablas_df
}
