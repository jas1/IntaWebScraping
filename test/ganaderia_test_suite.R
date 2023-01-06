library(testthat)
library(here)
library(config)


# 01 - leer configuracion -------------------------------------------------

# leer_configuracion_scrap <- leer_configuracion()
testthat::test_that("leer_configuracion_scrap",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  leer_configuracion_scrap <- leer_configuracion()
  #leer_configuracion_scrap$default$scrap_recursos_ganaderia_url

  # scrap_recursos_ganaderia_url:"https://www.rosgan.com.ar/precios-rosgan/"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_ganaderia_url"]],expected = "https://www.rosgan.com.ar/precios-rosgan/")
  # scrap_recursos_ganaderia_dest_file_pattern:"{timestamp_webscrap}_precios_ganaderia_tambo.html"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_ganaderia_dest_file_pattern"]],expected = "{timestamp_webscrap}_precios_ganaderia_tambo.html")
  # scrap_raw_store_ganaderia_folder:"tmp/ganaderia"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_raw_store_ganaderia_folder"]],expected = "tmp/raw/ganaderia")
  # scrap_timestamp_format:"%Y%m%d"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_timestamp_format"]],expected = "%Y%m%d")


})


# 01.a - validar configuracion -------------------------------------------------

# config_valida <- validar_configuracion(leer_configuracion_scrap)
testthat::test_that("validar_configuracion",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","validar_url.R"))
  source(here::here("R","validar_configuracion.R"))

  leer_configuracion_scrap <- leer_configuracion()
  #leer_configuracion_scrap$default$scrap_recursos_ganaderia_url

  config_valida <- validar_configuracion(leer_configuracion_scrap)



  # scrap_recursos_ganaderia_url:"https://www.rosgan.com.ar/precios-rosgan/"
  testthat::expect_equal(config_valida[["scrap_recursos_ganaderia_url"]],expected = "https://www.rosgan.com.ar/precios-rosgan/")
  # scrap_recursos_ganaderia_dest_file_pattern:"{timestamp_webscrap}_precios_ganaderia_tambo.html"
  testthat::expect_equal(config_valida[["scrap_recursos_ganaderia_dest_file_pattern"]],expected = "{timestamp_webscrap}_precios_ganaderia_tambo.html")
  # scrap_raw_store_ganaderia_folder:"tmp/ganaderia"
  testthat::expect_equal(config_valida[["scrap_raw_store_ganaderia_folder"]],expected = "tmp/raw/ganaderia")
  # scrap_timestamp_format:"%Y%m%d"
  testthat::expect_equal(config_valida[["scrap_timestamp_format"]],expected = "%Y%m%d")

  testthat::expect_equal(config_valida[["datos_store_ganaderia_folder"]],expected = "tmp/datos/ganaderia")

  testthat::expect_equal(config_valida[["destino_recursos_url"]],expected = "https://docs.google.com/spreadsheets/d/1wayzYcUboTRu3BNpfJxWQXEJ8-lcWJW0UBC9iAqE4xo/edit#gid=0")

  testthat::expect_equal(config_valida[["destino_ganaderia_sheet"]],expected = "ganaderia")

})

# 02 - obtener_datos_recursos_ganaderia -------------------------------------------------
# obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
testthat::test_that("obtener_datos_recursos_ganaderia",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)


  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
})

# 03 - leer_datos_ganaderia_crudos -------------------------------------------------
# funciona en el test, pero cuando se corre en targets no se puede separar la parte de xml
# asi tira el error de Last error: external pointer is not valid
# asi quito la tarea de leer, y la incluyo en la siguiente de procesar.
#
#
# testthat::test_that("leer_datos_ganaderia_crudos",{
#   #Sys.setenv(R_CONFIG_ACTIVE = "default")
#   source(here::here("R","leer_configuracion.R"))
#   source(here::here("R","get_datos_recursos_ganaderia_func.R"))
#   source(here::here("R","get_raw_web_file.R"))
#
#
#   leer_configuracion_scrap <- leer_configuracion()
#
#   # ----------------------------
#   obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
#   testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
#   # ----------------------------
#
#
#   leer_datos_ganaderia_crudos
#
#   testthat::expect_type(leer_datos_ganaderia_crudos,type = "list")
#   testthat::expect_equal(class(leer_datos_ganaderia_crudos),expected = c("xml_document","xml_node"))
#
# })


# 04 - procesar_datos_ganaderia_valores_actuales -------------------------------------------------
# procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales(leer_datos_ganaderia_crudos)
testthat::test_that("procesar_datos_ganaderia_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))

  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)
  procesar_datos_ganaderia_valores_actuales

  testthat::expect_type(procesar_datos_ganaderia_valores_actuales,type = "list")
  testthat::expect_equal(class(procesar_datos_ganaderia_valores_actuales),expected = c("tbl_df","tbl","data.frame"))
  cols_df <- colnames(procesar_datos_ganaderia_valores_actuales)
  cols_expected <- c("indices_tabla","valores_tabla","indices_fecha_str","origen")

  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true("terneros/as"  %in% procesar_datos_ganaderia_valores_actuales[["indices_tabla"]])

})




# 05 - transformar_datos_ganaderia_valores_actuales -------------------------------------------------
# transformar_datos_ganaderia_valores_actuales <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
testthat::test_that("transformar_datos_ganaderia_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_ganaderia_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_ganaderia_valores_actuales <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  transformar_datos_ganaderia_valores_actuales
  cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen","actualizado_fecha")
  cols_df <- colnames(transformar_datos_ganaderia_valores_actuales)
  cant_rows <- nrow(transformar_datos_ganaderia_valores_actuales)
  testthat::expect_equal(cant_rows, expected = 1)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true("terneros/as"  %in% transformar_datos_ganaderia_valores_actuales[["indices_tabla"]])
})


# 05.a - transformar_datos_tambo_valores_actuales_func -------------------------------------------------
# transformar_datos_tambo_valores_actuales_func <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
testthat::test_that("transformar_datos_tambo_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_tambo_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_ganaderia_valores_actuales <- transformar_datos_tambo_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  transformar_datos_ganaderia_valores_actuales
  cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen","actualizado_fecha")
  cols_df <- colnames(transformar_datos_ganaderia_valores_actuales)
  cant_rows <- nrow(transformar_datos_ganaderia_valores_actuales)
  testthat::expect_equal(cant_rows, expected = 1)
  testthat::expect_equal(cols_df,expected = cols_expected)
  testthat::expect_true("vacas c/gtía. de preñez"  %in% transformar_datos_ganaderia_valores_actuales[["indices_tabla"]])
})

# lo almaceno como ganaderia o con recurso ? si recurso agregarle valores viejos:
# 06 - almacenar_datos_ganaderia_valores_actuales_func -------------------------------------------------
# almacenar_datos_ganaderia_valores_actuales <- almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales)
testthat::test_that("almacenar_datos_ganaderia_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_ganaderia_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_ganaderia_valores_actuales <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales,leer_configuracion_scrap)

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
  testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})


# lo almaceno como ganaderia o con recurso ? si recurso agregarle valores viejos:
# 06.a - almacenar_datos_tambo_valores_actuales_func -------------------------------------------------
# almacenar_datos_ganaderia_valores_actuales <- almacenar_datos_tambo_valores_actuales_func(transformar_datos_ganaderia_valores_actuales)
testthat::test_that("almacenar_datos_tambo_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_tambo_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_tambo_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_tambo_valores_actuales <- transformar_datos_tambo_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_tambo_valores_actuales_func(transformar_datos_tambo_valores_actuales,leer_configuracion_scrap)

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
  testthat::expect_true("vacas c/gtía. de preñez"  %in% resultado_file_almacenar[["indices_tabla"]])
})



# 07 - disponibilizar_datos_ganaderia_valores_actuales_func -------------------------------------------------
# disponibilizar_datos_ganaderia_valores_actuales <- disponibilizar_datos_ganaderia_valores_actuales_func(path_files,cfg)

testthat::test_that("disponibilizar_datos_ganaderia_valores_actuales",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))

  source(here::here("R","disponibilizar_datos_ganaderia_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_ganaderia_valores_actuales <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales,leer_configuracion_scrap)

  resultado_file_almacenar <- readr::read_tsv(resultado_almacenar_path)
  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_ganaderia_valores_actuales_func(resultado_almacenar_path,leer_configuracion_scrap)


  testthat::expect_true(resultado_disponibilizar[["url"]]==leer_configuracion_scrap[["destino_recursos_url"]])
  testthat::expect_true(resultado_disponibilizar[["sheet"]]==leer_configuracion_scrap[["destino_ganaderia_sheet"]])
  # ----------------------------

  #install.packages('googlesheets4')

  # cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen")
  # cols_df <- colnames(resultado_file_almacenar)
  # cant_rows <- nrow(resultado_file_almacenar)
  # testthat::expect_equal(cant_rows, expected = 1)
  # testthat::expect_equal(cols_df,expected = cols_expected)
  # testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})

# 08 - validar_disponible_datos_ganaderia_valores_actuales_func -------------------------------------------------
# validar_disponible_datos_ganaderia_valores_actuales <- validar_disponible_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,disponibilizar_datos_ganaderia_valores_actuales)

testthat::test_that("validar_disponible_datos_ganaderia_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))
  source(here::here("R","disponibilizar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","validar_disponible_datos_ganaderia_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_ganaderia_valores_actuales <- transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_ganaderia_valores_actuales_func(resultado_almacenar_path,leer_configuracion_scrap)

  # ----------------------------
  resultado_validar <- validar_disponible_datos_ganaderia_valores_actuales_func(resultado_almacenar_path,resultado_disponibilizar,leer_configuracion_scrap)

  resultado_validar[["almacenar_df"]]
  resultado_validar[["sheet_df"]]

  testthat::expect_true(resultado_validar[["status"]])
  #install.packages('googlesheets4')

  # cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen")
  # cols_df <- colnames(resultado_file_almacenar)
  # cant_rows <- nrow(resultado_file_almacenar)
  # testthat::expect_equal(cant_rows, expected = 1)
  # testthat::expect_equal(cols_df,expected = cols_expected)
  # testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})

# 08.a - validar_disponible_datos_ganaderia_valores_actuales_func -------------------------------------------------
# validar_disponible_datos_ganaderia_valores_actuales <- validar_disponible_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,disponibilizar_datos_ganaderia_valores_actuales)

testthat::test_that("validar_disponible_datos_ganaderia_valores_actuales_func",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","get_datos_recursos_ganaderia_func.R"))
  source(here::here("R","get_raw_web_file.R"))

  source(here::here("R","procesar_datos_ganaderia_valores_actuales_func.R"))
  source(here::here("R","extract_rosgan_updated_header.R"))
  source(here::here("R","parse_fecha.R"))
  source(here::here("R","parse_fecha_rosgan.R"))
  source(here::here("R","get_mes_segun_fecha.R"))
  source(here::here("R","get_dia_segun_fecha.R"))
  source(here::here("R","get_anio_segun_fecha.R"))
  source(here::here("R","transformar_datos_tambo_valores_actuales_func.R"))
  source(here::here("R","almacenar_datos_tambo_valores_actuales_func.R"))
  source(here::here("R","auth_google_sheets.R"))
  source(here::here("R","disponibilizar_datos_tambo_valores_actuales_func.R"))
  source(here::here("R","validar_disponible_datos_tambo_valores_actuales_func.R"))


  leer_configuracion_scrap <- leer_configuracion()

  # ----------------------------
  obtener_datos_recursos_ganaderia <- get_datos_recursos_ganaderia_func(leer_configuracion_scrap)
  testthat::expect_true(file.exists(obtener_datos_recursos_ganaderia))
  # ----------------------------



  # ----------------------------

  procesar_datos_ganaderia_valores_actuales <- procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)

  # ----------------------------

  transformar_datos_tambo_valores_actuales <- transformar_datos_tambo_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)

  # ----------------------------
  resultado_almacenar_path <- almacenar_datos_tambo_valores_actuales_func(transformar_datos_tambo_valores_actuales,leer_configuracion_scrap)

  # ----------------------------
  resultado_disponibilizar <- disponibilizar_datos_tambo_valores_actuales_func(resultado_almacenar_path,leer_configuracion_scrap)

  # ----------------------------
  resultado_validar <- validar_disponible_datos_tambo_valores_actuales_func(resultado_almacenar_path,resultado_disponibilizar,leer_configuracion_scrap)

  resultado_validar[["almacenar_df"]]
  resultado_validar[["sheet_df"]]

  testthat::expect_true(resultado_validar[["status"]])
  #install.packages('googlesheets4')

  # cols_expected <- c("indices_tabla","indices_fecha","valores_tabla","explotacion","origen")
  # cols_df <- colnames(resultado_file_almacenar)
  # cant_rows <- nrow(resultado_file_almacenar)
  # testthat::expect_equal(cant_rows, expected = 1)
  # testthat::expect_equal(cols_df,expected = cols_expected)
  # testthat::expect_true("terneros/as"  %in% resultado_file_almacenar[["indices_tabla"]])
})
