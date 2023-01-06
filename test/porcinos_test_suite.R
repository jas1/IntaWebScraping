library(testthat)
library(here)
library(config)


# 01 - leer configuracion -------------------------------------------------

# leer_configuracion_scrap <- leer_configuracion()
testthat::test_that("leer_configuracion_scrap",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  leer_configuracion_scrap <- leer_configuracion()
  #leer_configuracion_scrap$default$scrap_recursos_porcinos_url

  # scrap_recursos_porcinos_url:"https://www.rosgan.com.ar/precios-rosgan/"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_porcinos_url"]],expected = "https://capper.org.ar/")
  # scrap_recursos_porcinos_dest_file_pattern:"{timestamp_webscrap}_precios_rosgan.html"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_porcinos_dest_file_pattern"]],expected = "{timestamp_webscrap}_precios_porcinos.html")
  # scrap_raw_store_porcinos_folder:"tmp/porcinos"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_raw_store_porcinos_folder"]],expected = "tmp/raw/porcinos")
  # scrap_timestamp_format:"%Y%m%d"
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
  #leer_configuracion_scrap$default$scrap_recursos_porcinos_url

  config_valida <- validar_configuracion(leer_configuracion_scrap)

  # la config se valida en el anterior
  # este revienta en la funcion en caso de no pasar. si pasa devuelve la configuracion que levanto.
  testthat::expect_true(leer_configuracion_scrap[["scrap_recursos_porcinos_url"]] ==config_valida[["scrap_recursos_porcinos_url"]])



})

# 02 - obtener_datos_recursos_porcinos -------------------------------------------------
# obtener_datos_recursos_porcinos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)
testthat::test_that("get_datos_recursos_porcinos",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)


  testthat::expect_true(file.exists(raw_datos))
})

# 03 - leer_datos_porcinos_crudos -------------------------------------------------
# leer_datos_porcinos_crudos <- leer_datos_porcinos_crudos_func(obtener_datos_recursos_porcinos)
# funciona en el test, pero cuando se corre en targets no se puede separar la parte de xml
# asi tira el error de Last error: external pointer is not valid
# asi quito la tarea de leer, y la incluyo en la siguiente de procesar.
# testthat::test_that("leer_datos_porcinos_crudos",{
#   #Sys.setenv(R_CONFIG_ACTIVE = "default")
#   source(here::here("R","leer_configuracion.R"))
#   source(here::here("R","get_datos_recursos_porcinos_func.R"))
#   source(here::here("R","get_raw_web_file.R"))
#
#
#   leer_configuracion_scrap <- leer_configuracion()
#
#   # ----------------------------
#   raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)
#   # ----------------------------
#
#
#
#
#   testthat::expect_type(leer_datos,type = "list")
#   testthat::expect_equal(class(leer_datos),expected = c("xml_document","xml_node"))
#
# })


# 04 - procesar_datos_porcinos_valores_actuales -------------------------------------------------
# procesar_datos_porcinos_valores_actuales <- procesar_datos_porcinos_valores_actuales(leer_datos_porcinos_crudos)
testthat::test_that("procesar_datos_porcinos_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","extract_capper_main_capon_data.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)
  # ----------------------------



  # ----------------------------

  procesar_datos <- procesar_datos_porcinos_valores_actuales_func(raw_datos)
  procesar_datos

  testthat::expect_type(procesar_datos,type = "list")
  testthat::expect_equal(class(procesar_datos),expected = c("tbl_df","tbl","data.frame"))
  cols_df <- colnames(procesar_datos)
  cols_expected <- c('precio_desc','valor','categoria_desc')

  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(all(stringr::str_detect(procesar_datos[["categoria_desc"]],"Capón")))

})




# 05 - transformar_datos_porcinos_valores_actuales -------------------------------------------------
# transformar_datos_porcinos_valores_actuales <- transformar_datos_porcinos_valores_actuales_func(procesar_datos_porcinos_valores_actuales)
testthat::test_that("transformar_datos_porcinos_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","extract_capper_main_capon_data.R"))
  source(here::here("R","transformar_datos_porcinos_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  porcesados_datos <- procesar_datos_porcinos_valores_actuales_func(raw_datos)

  # ----------------------------

  transform_datos <- transformar_datos_porcinos_valores_actuales_func(porcesados_datos)

  cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen","actualizado_fecha")
  cols_df <- colnames(transform_datos)
  cant_rows <- nrow(transform_datos)
  testthat::expect_equal(cant_rows, expected = 1)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(all(stringr::str_detect(transform_datos[["indices_tabla"]],"Capón")))
})


# lo almaceno como porcinos o con recurso ? si recurso agregarle valores viejos:
# 06 - almacenar_datos_porcinos_valores_actuales_func -------------------------------------------------
# almacenar_datos_porcinos_valores_actuales <- almacenar_datos_porcinos_valores_actuales_func(transformar_datos_porcinos_valores_actuales)
testthat::test_that("almacenar_datos_porcinos_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","extract_capper_main_capon_data.R"))
  source(here::here("R","transformar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_porcinos_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  porcesados_datos <- procesar_datos_porcinos_valores_actuales_func(raw_datos)

  # ----------------------------

  transform_datos <- transformar_datos_porcinos_valores_actuales_func(porcesados_datos)
  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_porcinos_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  resultado_archivo_existe <- fs::file_exists(path = resultado_almacenar_path)

  testthat::expect_true(resultado_archivo_existe)

  resultado_file_almacenar <- readr::read_tsv(resultado_almacenar_path)



  # ----------------------------

  #install.packages('googlesheets4')

  cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen","actualizado_fecha")
  cols_df <- colnames(resultado_file_almacenar)
  cant_rows <- nrow(resultado_file_almacenar)
  testthat::expect_equal(cant_rows, expected = 1)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true(stringr::str_detect(resultado_file_almacenar[["indices_tabla"]],"Capón"))
})


# 07 - disponibilizar_datos_porcinos_valores_actuales_func -------------------------------------------------
# disponibilizar_datos_porcinos_valores_actuales <- disponibilizar_datos_porcinos_valores_actuales_func(path_files,cfg)

testthat::test_that("disponibilizar_datos_porcinos_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","extract_capper_main_capon_data.R"))
  source(here::here("R","transformar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))

  source(here::here("R","disponibilizar_datos_porcinos_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  porcesados_datos <- procesar_datos_porcinos_valores_actuales_func(raw_datos)

  # ----------------------------

  transform_datos <- transformar_datos_porcinos_valores_actuales_func(porcesados_datos)
  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_porcinos_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_porcinos_valores_actuales_func(resultado_almacenar_path,leer_configuracion_scrap)


  testthat::expect_true(resultado_disponibilizar[["url"]]==leer_configuracion_scrap[["destino_recursos_url"]])
  testthat::expect_true(resultado_disponibilizar[["sheet"]]==leer_configuracion_scrap[["destino_porcinos_sheet"]])
  # ----------------------------

  #install.packages('googlesheets4')

  # cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen")
  # cols_df <- colnames(resultado_file_almacenar)
  # cant_rows <- nrow(resultado_file_almacenar)
  # testthat::expect_equal(cant_rows, expected = 1)
  # testthat::expect_equal(cols_df,expected = cols_expected)
  # testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})

# 08 - validar_disponible_datos_porcinos_valores_actuales_func -------------------------------------------------
# validar_disponible_datos_porcinos_valores_actuales <- validar_disponible_datos_porcinos_valores_actuales_func(almacenar_datos_porcinos_valores_actuales,disponibilizar_datos_porcinos_valores_actuales)

testthat::test_that("validar_disponible_datos_porcinos_valores_actuales_func",{

  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_porcinos_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","extract_capper_main_capon_data.R"))
  source(here::here("R","transformar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))

  source(here::here("R","disponibilizar_datos_porcinos_valores_actuales_func.R"))
  source(here::here("R","validar_disponible_datos_porcinos_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  raw_datos <- get_datos_recursos_porcinos_func(leer_configuracion_scrap)

  # ----------------------------



  # ----------------------------

  porcesados_datos <- procesar_datos_porcinos_valores_actuales_func(raw_datos)

  # ----------------------------

  transform_datos <- transformar_datos_porcinos_valores_actuales_func(porcesados_datos)
  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_porcinos_valores_actuales_func(transform_datos,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_porcinos_valores_actuales_func(resultado_almacenar_path,leer_configuracion_scrap)

  # ----------------------------
  resultado_validar <- validar_disponible_datos_porcinos_valores_actuales_func(resultado_almacenar_path,resultado_disponibilizar,leer_configuracion_scrap)

  testthat::expect_true(resultado_validar[["status"]])

})
