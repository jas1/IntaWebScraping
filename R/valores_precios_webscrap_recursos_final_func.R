valores_precios_webscrap_recursos_final_func <- function(config){
  # de la config se extraen todos los nombres de las hojas input:
  # destino_ganaderia_sheet,
  # destino_tambo_sheet,
  # destino_porcinos_sheet,
  # destino_carne_ave_sheet,
  # destino_huevo_sheet
  # y hoja destino: config[["destino_valores_precios_webscrap_final_sheet"]]

  # output final web scrap:
  # porcinos: precio:  precio máximo capón
  # carne_ave: precio: Precio polla recriada blanca  18 meses
  # huevo: precio final: Precio polla recriada blanca 16 semanas
  # tambo: precio final: precio "vaca con garantia de preñez"
  # ganaderia: precio final: (precio "terneros/as"* *175)
  # source(here::here("R","leer_configuracion.R"))
  # config <- leer_configuracion()
  # source(here::here("R","auth_google_sheets.R"))
  auth_google_sheets(config)

  # para este caso no hace falta hacer cosas raras
  porcinos_valor <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                               sheet = config[['destino_porcinos_sheet']])|>
    dplyr::mutate(precio=valores_tabla)

  # para carne de ave te trae varios valores la pagina, entonces te quedas con el mas reciente.
  carne_ave_df <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                              sheet = config[['destino_carne_ave_sheet']])
  carne_ave_valor <- carne_ave_df |> dplyr::filter(indices_fecha==max(indices_fecha))|>
    dplyr::mutate(precio=valores_tabla)

  # para huevo te trae varios valores la pagina, entonces te quedas con el mas reciente.
  huevo_df <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                            sheet = config[['destino_huevo_sheet']])
  huevo_valor <- huevo_df |> dplyr::filter(indices_fecha==max(indices_fecha))|>
    dplyr::mutate(precio=valores_tabla)

  # es obtener la columna valores_tabla
  tambo_valor <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                           sheet = config[['destino_tambo_sheet']]) |>
    dplyr::mutate(precio=valores_tabla)

  # es obtener la columna valores_tabla
  ganaderia_valor <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                                           sheet = config[['destino_ganaderia_sheet']]) |>
    dplyr::mutate(precio=valores_tabla*175)

  unir_todos_recurso <- purrr::reduce(list(porcinos_valor,
                                           carne_ave_valor,
                                           huevo_valor,
                                           tambo_valor,
                                           ganaderia_valor),
                                      .f = dplyr::union)

  googlesheets4::write_sheet(data=unir_todos_recurso,
                             ss = config[['destino_recursos_url']],
                             sheet = config[['destino_valores_precios_recursos_webscrap_final_sheet']])

  unir_todos_recurso

}
