
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

  # scrap_recursos_huevo_url:"https://www.rosgan.com.ar/precios-rosgan/"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_ave_url"]],expected = "https://www.capia.com.ar/estadisticas/precio-del-huevo-semanal")
  # scrap_recursos_huevo_dest_file_pattern:"{timestamp_webscrap}_precios_rosgan.html"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_recursos_ave_huevo_dest_file_pattern"]],expected = "{timestamp_webscrap}_precios_ave_huevo.html")
  # scrap_raw_store_huevo_folder:"tmp/huevo"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_raw_store_ave_huevo_folder"]],expected = "tmp/raw/ave_huevo")
  # scrap_timestamp_format:"%Y%m%d"
  testthat::expect_equal(leer_configuracion_scrap[["scrap_timestamp_format"]],expected = "%Y%m%d")


})

# escribir_valores_precios_recursos_test

testthat::test_that("leer_configuracion_scrap",{
  #Sys.setenv(R_CONFIG_ACTIVE = "default")
  source(here::here("R","leer_configuracion.R"))
  source(here::here("R","valores_precios_webscrap_recursos_final_func.R"))
  source(here::here("R","auth_google_sheets.R"))

  config <- leer_configuracion()
  result <- valores_precios_webscrap_recursos_final_func(config)

  auth_google_sheets(config)
  output <- googlesheets4::read_sheet(ss = config[['destino_recursos_url']],
                             sheet = config[['destino_valores_precios_recursos_webscrap_final_sheet']])

  testthat::expect_true(all(result==output))
})


