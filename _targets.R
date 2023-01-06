library(targets)
library(tarchetypes)

source("R/functions.r")
options(tidyverse.quiet = TRUE)
targets::tar_option_set(packages = c("here","config","dplyr", "readr", "tidyr","rvest","googlesheets4"))

leer_configuracion
list(
  # levantar config
  targets::tar_target(
    leer_configuracion_scrap,
    leer_configuracion()
  ),
  targets::tar_target(
    config_valida,
    validar_configuracion(leer_configuracion_scrap)
  ),

  # 1. obtener los datos crudos: ganaderia y tambos: bajar la pagina.
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_ganaderia,
    get_datos_recursos_ganaderia_func(config_valida)
  ),
  # 1.a obtener los datos crudos: porcinos: bajar la pagina.
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_porcinos,
    get_datos_recursos_porcinos_func(config_valida)
  ),
  # 1.b obtener los datos crudos: ave huevos: bajar la pagina.
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_ave_huevos,
    get_datos_recursos_ave_huevos_func(config_valida)
  ),
  # 2. procesar los datos obtenidos: ganaderia: leer los datos crudos
  # devuelve el html
  targets::tar_target(
    leer_datos_ganaderia_crudos,
    leer_datos_ganaderia_crudos_func(obtener_datos_recursos_ganaderia)
  ),
  # 2.a procesar los datos obtenidos: porcinos: leer los datos crudos
  # devuelve el html
  targets::tar_target(
    leer_datos_porcinos_crudos,
    leer_datos_porcinos_crudos_func(obtener_datos_recursos_porcinos)
  ),
  # 2.b procesar los datos obtenidos: porcinos: leer los datos crudos
  # devuelve el html
  targets::tar_target(
    leer_datos_ave_huevos_crudos,
    leer_datos_ave_huevos_crudos_func(obtener_datos_recursos_ave_huevos)
  ),

  # 3. procesar los datos obtenidos: ganaderia: extraer los datos
  targets::tar_target(
    procesar_datos_ganaderia_valores_actuales,
    procesar_datos_ganaderia_valores_actuales_func(leer_datos_ganaderia_crudos)
  ),
  # 3.a procesar los datos obtenidos: porcinos: extraer los datos
  targets::tar_target(
    procesar_datos_porcinos_valores_actuales,
    procesar_datos_porcinos_valores_actuales_func(leer_datos_porcinos_crudos)
  ),
  # 3.b procesar los datos obtenidos: ave huevos: extraer los datos
  targets::tar_target(
    procesar_datos_ave_huevos_valores_actuales,
    procesar_datos_ave_huevos_valores_actuales_func(leer_datos_ave_huevos_crudos)
  ),
  # 4. procesar los datos obtenidos: ganaderia: transformar los datos
  targets::tar_target(
    transformar_datos_ganaderia_valores_actuales,
    transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  ),
  # 4.a procesar los datos obtenidos: tambo: transformar los datos
  targets::tar_target(
    transformar_datos_tambo_valores_actuales,
    transformar_datos_tambo_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  ),
  # 4.b procesar los datos obtenidos: porcinos: transformar los datos
  targets::tar_target(
    transformar_datos_porcinos_valores_actuales,
    transformar_datos_porcinos_valores_actuales_func(procesar_datos_porcinos_valores_actuales)
  ),
  # 4.c procesar los datos obtenidos: carne_ave: transformar los datos
  targets::tar_target(
    transformar_datos_carne_ave_valores_actuales,
    transformar_datos_carne_ave_valores_actuales_func(procesar_datos_ave_huevos_valores_actuales)
  ),
  # 4.d procesar los datos obtenidos: carne_ave: transformar los datos
  targets::tar_target(
    transformar_datos_huevo_valores_actuales,
    transformar_datos_huevo_valores_actuales_func(procesar_datos_ave_huevos_valores_actuales)
  ),
  # 5. procesar los datos obtenidos: ganaderia: almacenar los datos
  targets::tar_target(
    almacenar_datos_ganaderia_valores_actuales,
    almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales,config_valida)
  ),
  # 5.a procesar los datos obtenidos: tambo: almacenar los datos
  targets::tar_target(
    almacenar_datos_tambo_valores_actuales,
    almacenar_datos_tambo_valores_actuales_func(transformar_datos_tambo_valores_actuales,config_valida)
  ),
  # 5.b procesar los datos obtenidos: porcinos: almacenar los datos
  targets::tar_target(
    almacenar_datos_porcinos_valores_actuales,
    almacenar_datos_porcinos_valores_actuales_func(transformar_datos_porcinos_valores_actuales,config_valida)
  ),
  # 5.c procesar los datos obtenidos: carne_ave: almacenar los datos
  targets::tar_target(
    almacenar_datos_carne_ave_valores_actuales,
    almacenar_datos_carne_ave_valores_actuales_func(transformar_datos_carne_ave_valores_actuales,config_valida)
  ),
  # 5.d procesar los datos obtenidos: huevo: almacenar los datos
  targets::tar_target(
    almacenar_datos_huevo_valores_actuales,
    almacenar_datos_huevo_valores_actuales_func(transformar_datos_huevo_valores_actuales,config_valida)
  ),
  # 6. disponibilizar los datos procesados
  targets::tar_target(
    disponibilizar_datos_ganaderia_valores_actuales,
    disponibilizar_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,config_valida)
  ),
  # 6.a disponibilizar los datos procesados
  targets::tar_target(
    disponibilizar_datos_tambo_valores_actuales,
    disponibilizar_datos_tambo_valores_actuales_func(almacenar_datos_tambo_valores_actuales,config_valida)
  ),
  # 6.b disponibilizar los datos procesados
  targets::tar_target(
    disponibilizar_datos_porcinos_valores_actuales,
    disponibilizar_datos_porcinos_valores_actuales_func(almacenar_datos_porcinos_valores_actuales,config_valida)
  ),
  # 6.c disponibilizar los datos procesados
  targets::tar_target(
    disponibilizar_datos_carne_ave_valores_actuales,
    disponibilizar_datos_carne_ave_valores_actuales_func(almacenar_datos_carne_ave_valores_actuales,config_valida)
  ),
  # 6.d disponibilizar los datos procesados
  targets::tar_target(
    disponibilizar_datos_huevo_valores_actuales,
    disponibilizar_datos_huevo_valores_actuales_func(almacenar_datos_huevo_valores_actuales,config_valida)
  ),
  # 7. validar datos disponibilizados
  targets::tar_target(
    validar_disponible_datos_ganaderia_valores_actuales,
    validar_disponible_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,disponibilizar_datos_ganaderia_valores_actuales,config_valida)
  ),
  # 7.a validar datos disponibilizados
  targets::tar_target(
    validar_disponible_datos_tambo_valores_actuales,
    validar_disponible_datos_tambo_valores_actuales_func(almacenar_datos_tambo_valores_actuales,disponibilizar_datos_tambo_valores_actuales,config_valida)
  ),
  # 7.b validar datos disponibilizados
  targets::tar_target(
    validar_disponible_datos_porcinos_valores_actuales,
    validar_disponible_datos_porcinos_valores_actuales_func(almacenar_datos_porcinos_valores_actuales,disponibilizar_datos_porcinos_valores_actuales,config_valida)
  ),
  # 7.c validar datos disponibilizados
  targets::tar_target(
    validar_disponible_datos_huevo_valores_actuales,
    validar_disponible_datos_huevo_valores_actuales_func(almacenar_datos_huevo_valores_actuales,disponibilizar_datos_huevo_valores_actuales,config_valida)
  ),
  # 7.d validar datos disponibilizados
  targets::tar_target(
    validar_disponible_datos_carne_ave_valores_actuales,
    validar_disponible_datos_carne_ave_valores_actuales_func(almacenar_datos_carne_ave_valores_actuales,disponibilizar_datos_carne_ave_valores_actuales,config_valida)
  ),
  # repetir pasos para resto de recursos y lluvias
  # 3. pre process data
  # targets::tar_target(
  #   data,
  #   raw_data %>%
  #     filter(!is.na(Ozone))
  # ),
  # # 4. make histogram plot
  # targets::tar_target(hist, create_plot(data)),
  # # 5. make fit of data
  # targets::tar_target(fit, biglm(Ozone ~ Wind + Temp, data)),
  # # 6. render a report
  # targets::tar_render(report, "reports/index.Rmd")
)
