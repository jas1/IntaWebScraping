library(testthat)
library(here)
library(config)


# 01 - leer configuracion -------------------------------------------------

# leer_configuracion_scrap <- leer_configuracion()
testthat::test_that("leer_configuracion_scrap",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  leer_configuracion_scrap <- leer_configuracion()
  #leer_configuracion_scrap$default$scrap_recursos_huevo_url

  testthat::expect_equal(leer_configuracion_scrap[["scrap_precipitaciones_url"]],expected = "https://www.hidraulica.gob.ar/redPluviometricaHist.php")
  testthat::expect_equal(leer_configuracion_scrap[["scrap_precipitaciones_dest_file_pattern"]],expected = "{timestamp_webscrap}_precipitaciones.html")
  testthat::expect_equal(leer_configuracion_scrap[["scrap_raw_store_precipitaciones_folder"]],expected = "tmp/raw/precipitaciones")

  testthat::expect_equal(leer_configuracion_scrap[["datos_store_precipitaciones_folder"]],expected = "tmp/datos/precipitaciones")
  testthat::expect_equal(leer_configuracion_scrap[["datos_precipitaciones_dest_file_pattern"]],expected = "{timestamp_datos}_precipitaciones.txt")
  testthat::expect_equal(leer_configuracion_scrap[["destino_precipitaciones_sheet"]],expected = "precipitaciones")

  testthat::expect_equal(leer_configuracion_scrap[["scrap_timestamp_format"]],expected = "%Y%m%d")

})


# 01.a - validar configuracion -------------------------------------------------

# config_valida <- validar_configuracion(leer_configuracion_scrap)
testthat::test_that("validar_configuracion",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","validar_url.R"))
  source(here::here("R","validar_crear_path_guardar.R"))
  source(here::here("R","validar_configuracion.R"))

  leer_configuracion_scrap <- leer_configuracion()
  #leer_configuracion_scrap$default$scrap_recursos_huevo_url

  config_valida <- validar_configuracion(leer_configuracion_scrap)

  # la config se valida en el anterior
  # este revienta en la funcion en caso de no pasar. si pasa devuelve la configuracion que levanto.
  testthat::expect_equal(leer_configuracion_scrap[["scrap_precipitaciones_url"]],expected = "https://www.hidraulica.gob.ar/redPluviometricaHist.php")

})

# 02 - get_datos_precipitaciones -------------------------------------------------
# obtener_datos_recursos_huevo <- get_datos_precipitaciones_func(leer_configuracion_scrap)
testthat::test_that("get_datos_precipitaciones_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)


  testthat::expect_true(file.exists(raw_datos))
})

# 03 - leer_datos_precipitaciones_crudos -------------------------------------------------
# leer_datos_huevo_crudos <- leer_datos_precipitaciones_crudos_func(obtener_datos_recursos_huevo)
# funciona en el test, pero cuando se corre en targets no se puede separar la parte de xml
# asi tira el error de Last error: external pointer is not valid
# asi quito la tarea de leer, y la incluyo en la siguiente de procesar.
# testthat::test_that("leer_datos_precipitaciones_crudos_func",{
#   #Sys.setenv(R_CONFIG_ACTIVE = "default")
#   source(here::here("R","leer_configuracion.R"))
#   source(here::here("R","get_datos_precipitaciones_func.R"))
#   source(here::here("R","get_raw_web_file.R"))
#
#
#   leer_configuracion_scrap <- leer_configuracion()
#
#   # ----------------------------
#   raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)
#   # ----------------------------
#
#
#
#
#   testthat::expect_type(leer_datos,type = "list")
#   testthat::expect_equal(class(leer_datos),expected = c("xml_document","xml_node"))
#
# })


# 04 - procesar_datos_precipitaciones_valores_actuales_func -------------------------------------------------
# procesar_datos_huevo_valores_actuales <- procesar_datos_huevo_valores_actuales(leer_datos_huevo_crudos)
testthat::test_that("procesar_datos_precipitaciones_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","extract_precipitaciones_table.R"))
  source(here::here("R","extract_precipitaciones_table_identificar_tablas.R"))
  source(here::here("R","extract_precipitaciones_table_identificar_tablas_parsear_gris_y_data_tabla.R"))
  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)
  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_precipitaciones_valores_actuales_func(raw_datos)


  testthat::expect_type(procesar_datos,type = "list")
  testthat::expect_equal(class(procesar_datos),expected = c("data.frame"))
  cols_df <- colnames(procesar_datos)
  cols_expected <- c("estacion","valor","departamento","descripcion_fecha")

  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(all(stringr::str_detect(procesar_datos[["descripcion_fecha"]],"registradas")))

})




# 05 - transformar_datos_precipitaciones_valores_actuales -------------------------------------------------
# transformar_datos_precipitaciones_valores_actuales <- transformar_datos_precipitaciones_valores_actuales_func(procesar_datos_huevo_valores_actuales)
testthat::test_that("transformar_datos_precipitaciones_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))
  source(here::here("R","get_deptos_distritos_map.R"))
  source(here::here("R","extract_precipitaciones_table.R"))
  source(here::here("R","extract_precipitaciones_table_identificar_tablas.R"))
  source(here::here("R","extract_precipitaciones_table_identificar_tablas_parsear_gris_y_data_tabla.R"))
  source(here::here("R","transformar_datos_precipitaciones_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_precipitaciones_valores_actuales_func(raw_datos)

  # ----------------------------
  deptos_distritos_map <- get_deptos_distritos_map(leer_configuracion_scrap)
  transform_datos <- transformar_datos_precipitaciones_valores_actuales_func(procesar_datos,deptos_distritos_map)

  cols_expected <- c('indices_tabla','estacion','departamento','indices_fecha','valores_tabla','variable','origen','actualizado_fecha','distrito')
  cols_df <- colnames(transform_datos)
  # transform_datos |> dplyr::count(departamento,distrito)
  # transform_datos |> dplyr::filter(departamento=="Paraná") |> dplyr::filter(is.na(distrito))
  cant_rows <- nrow(transform_datos)
  testthat::expect_gt(cant_rows, expected = 0)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(all(stringr::str_detect(transform_datos[["indices_tabla"]],"recipitaciones registradas")))
})


# lo almaceno como huevo o con recurso ? si recurso agregarle valores viejos:
# 06 - almacenar_datos_precipitaciones_valores_actuales_func -------------------------------------------------
# almacenar_datos_precipitaciones_valores_actuales <- almacenar_datos_precipitaciones_valores_actuales_func(transformar_datos_huevo_valores_actuales)
testthat::test_that("almacenar_datos_precipitaciones_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))
  source(here::here("R","get_deptos_distritos_map.R"))
  source(here::here("R","transformar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_precipitaciones_valores_actuales_func.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_precipitaciones_valores_actuales_func(raw_datos)

  # ----------------------------
  deptos_distritos_map <- get_deptos_distritos_map(leer_configuracion_scrap)

  transform_datos <- transformar_datos_precipitaciones_valores_actuales_func(procesar_datos,deptos_distritos_map)
  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_precipitaciones_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  resultado_archivo_existe <- fs::file_exists(path = resultado_almacenar_path)

  testthat::expect_true(resultado_archivo_existe)

  resultado_file_almacenar <- readr::read_tsv(resultado_almacenar_path)



  # ----------------------------

  #install.packages('googlesheets4')
  cols_expected <- c('indices_tabla','estacion','departamento','indices_fecha','valores_tabla','variable','origen','actualizado_fecha','distrito')
  cols_df <- colnames(resultado_file_almacenar)
  # transform_datos |> dplyr::count(departamento,distrito)
  # transform_datos |> dplyr::filter(departamento=="Paraná") |> dplyr::filter(is.na(distrito))
  cant_rows <- nrow(resultado_file_almacenar)
  testthat::expect_gt(cant_rows, expected = 0)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(all(stringr::str_detect(resultado_file_almacenar[["indices_tabla"]],"recipitaciones registradas")))
})


# 07 - almacenar_datos_precipitaciones_valores_actuales_func -------------------------------------------------
# disponibilizar_datos_huevo_valores_actuales <- almacenar_datos_precipitaciones_valores_actuales_func(path_files,cfg)

testthat::test_that("almacenar_datos_precipitaciones_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","extract_capia_tables.R"))
  source(here::here("R","transformar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))
  source(here::here("R","disponibilizar_datos_precipitaciones_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_precipitaciones_valores_actuales_func(raw_datos)

  # ----------------------------

  deptos_distritos_map <- get_deptos_distritos_map(leer_configuracion_scrap)

  transform_datos <- transformar_datos_precipitaciones_valores_actuales_func(procesar_datos,deptos_distritos_map)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_precipitaciones_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_precipitaciones_valores_actuales_func(path_almacenado = resultado_almacenar_path,config =leer_configuracion_scrap )


  testthat::expect_true(resultado_disponibilizar[["url"]]==leer_configuracion_scrap[["destino_recursos_url"]])
  testthat::expect_true(resultado_disponibilizar[["sheet"]]==leer_configuracion_scrap[["destino_precipitaciones_sheet"]])
  # ----------------------------

  #install.packages('googlesheets4')

  # cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen")
  # cols_df <- colnames(resultado_file_almacenar)
  # cant_rows <- nrow(resultado_file_almacenar)
  # testthat::expect_equal(cant_rows, expected = 1)
  # testthat::expect_equal(cols_df,expected = cols_expected)
  # testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})

# 08 - validar_disponible_datos_precipitaciones_valores_actuales -------------------------------------------------
# validar_disponible_datos_precipitaciones_valores_actuales <- validar_disponible_datos_precipitaciones_valores_actuales_func(almacenar_datos_huevo_valores_actuales,disponibilizar_datos_huevo_valores_actuales)

testthat::test_that("validar_disponible_datos_precipitaciones_valores_actuales_func",{

  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_precipitaciones_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","extract_capia_tables.R"))
  source(here::here("R","transformar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))

  source(here::here("R","disponibilizar_datos_precipitaciones_valores_actuales_func.R"))
  source(here::here("R","validar_disponible_datos_precipitaciones_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_precipitaciones_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_precipitaciones_valores_actuales_func(raw_datos)

  # ----------------------------

  deptos_distritos_map <- get_deptos_distritos_map(leer_configuracion_scrap)

  transform_datos <- transformar_datos_precipitaciones_valores_actuales_func(procesar_datos,deptos_distritos_map)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_precipitaciones_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_precipitaciones_valores_actuales_func(path_almacenado = resultado_almacenar_path,config =leer_configuracion_scrap )

  # ----------------------------
  resultado_validar <- validar_disponible_datos_precipitaciones_valores_actuales_func(resultado_almacenar_path,resultado_disponibilizar,leer_configuracion_scrap)

  testthat::expect_true(resultado_validar[["status"]])

})
