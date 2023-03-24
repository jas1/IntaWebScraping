library(targets)
library(tarchetypes)

source("R/source_funciones.R")

options(tidyverse.quiet = TRUE)
targets::tar_option_set(packages = c("here","config","dplyr", "readr", "tidyr","httr","rvest","googlesheets4"))

leer_configuracion
list(
  # 0. levantar config ------------------------
  targets::tar_target(
    leer_configuracion_scrap,
    leer_configuracion()
  ),
  # 0.1 validar config ------------------------
  targets::tar_target(
    config_valida,
    validar_configuracion(leer_configuracion_scrap)
  ),
  # 0.2. validar las URL ------------------------
  # 0.2.a validar url ganaderia y tambo ------------------------
  targets::tar_target(
    url_valida_ganaderia_tambo,
    validar_url(config_valida[['scrap_recursos_ganaderia_url']])
  ),
  # 0.2.b validar url ganaderia porcinos ------------------------
  targets::tar_target(
    url_valida_porcinos,
    validar_url(config_valida[['scrap_recursos_porcinos_url']])
  ),
  # 0.2.c validar url carne ave huevos ------------------------
  targets::tar_target(
    url_valida_carne_ave_huevos,
    validar_url(config_valida[['scrap_recursos_ave_url']])
  ),
  # 0.2.d validar url carne ave huevos ------------------------
  targets::tar_target(
    url_valida_precipitaciones,
    validar_url(config_valida[['scrap_precipitaciones_url']])
  ),
  # 0.2.e validar url destino sheet ------------------------
  targets::tar_target(
    url_valida_destino_recursos_url,
    validar_url(config_valida[['destino_recursos_url']])
  ),
  # 0.2.f validar url destino informe ------------------------
  targets::tar_target(
    url_valida_destino_informes_url,
    validar_url(config_valida[['destino_informes_url']])
  ),


  # 1. obtener los datos crudos: ganaderia y tambos: bajar la pagina. ------------------------
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_ganaderia,
      get_datos_recursos_ganaderia_func(config_valida,url_valida_ganaderia_tambo)
  ),
  # 1.a obtener los datos crudos: porcinos: bajar la pagina. ------------------------
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_porcinos,
      get_datos_recursos_porcinos_func(config_valida,url_valida_porcinos)
  ),
  # 1.b obtener los datos crudos: ave huevos: bajar la pagina. ------------------------
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_ave_huevos,
      get_datos_recursos_ave_huevos_func(config_valida,url_valida_carne_ave_huevos)
  ),
  # 1.c obtener los datos crudos: precipitaciones: bajar la pagina. ------------------------
  # devuelve el path del archivo generado
  targets::tar_target(
    obtener_datos_recursos_precipitaciones,
      get_datos_precipitaciones_func(config_valida,url_valida_precipitaciones)
  ),
  # 2. procesar los datos obtenidos: ganaderia: leer los datos crudos
  # devuelve el html
  # targets::tar_target(
  #   leer_datos_ganaderia_crudos,
  #   leer_datos_ganaderia_crudos_func(obtener_datos_recursos_ganaderia)
  # ),
  # 2.a procesar los datos obtenidos: porcinos: leer los datos crudos
  # devuelve el html
  # targets::tar_target(
  #   leer_datos_porcinos_crudos,
  #   leer_datos_porcinos_crudos_func(obtener_datos_recursos_porcinos)
  # ),
  # 2.b procesar los datos obtenidos: porcinos: leer los datos crudos
  # devuelve el html
  # targets::tar_target(
  #   leer_datos_ave_huevos_crudos,
  #   leer_datos_ave_huevos_crudos_func(obtener_datos_recursos_ave_huevos)
  # ),
  # 2.c procesar los datos obtenidos: precipitaciones: leer los datos precipitaciones ------------------------
  # # devuelve el html
  # targets::tar_target(
  #   leer_datos_precipitaciones_crudos,
  #   leer_datos_precipitaciones_crudos_func(obtener_datos_recursos_precipitaciones)
  # ),
  # 3. procesar los datos obtenidos: ganaderia: extraer los datos ------------------------
  targets::tar_target(
    procesar_datos_ganaderia_valores_actuales,
    procesar_datos_ganaderia_valores_actuales_func(obtener_datos_recursos_ganaderia)
  ),
  # 3.a procesar los datos obtenidos: porcinos: extraer los datos ------------------------
  targets::tar_target(
    procesar_datos_porcinos_valores_actuales,
    procesar_datos_porcinos_valores_actuales_func(obtener_datos_recursos_porcinos)
  ),
  # 3.b procesar los datos obtenidos: ave huevos: extraer los datos ------------------------
  targets::tar_target(
    procesar_datos_ave_huevos_valores_actuales,
    procesar_datos_ave_huevos_valores_actuales_func(obtener_datos_recursos_ave_huevos)
  ),
  # 3.c.x mapeo ------------------------
  targets::tar_target(
    deptos_distritos_map,
      get_deptos_distritos_map(config_valida,url_valida_destino_recursos_url)
  ),
  # 3.c procesar los datos obtenidos: precipitaciones: extraer los datos ------------------------
  targets::tar_target(
    procesar_datos_precipitaciones_valores_actuales,
    procesar_datos_precipitaciones_valores_actuales_func(obtener_datos_recursos_precipitaciones)
  ),
  # 4. transformar: ganaderia: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_ganaderia_valores_actuales,
    transformar_datos_ganaderia_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  ),
  # 4.a transformar: tambo: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_tambo_valores_actuales,
    transformar_datos_tambo_valores_actuales_func(procesar_datos_ganaderia_valores_actuales)
  ),
  # 4.b transformar: porcinos: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_porcinos_valores_actuales,
    transformar_datos_porcinos_valores_actuales_func(procesar_datos_porcinos_valores_actuales)
  ),
  # 4.c transformar: carne_ave: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_carne_ave_valores_actuales,
    transformar_datos_carne_ave_valores_actuales_func(procesar_datos_ave_huevos_valores_actuales)
  ),
  # 4.d transformars: huevo: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_huevo_valores_actuales,
    transformar_datos_huevo_valores_actuales_func(procesar_datos_ave_huevos_valores_actuales)
  ),
  # 4.e transformar: precipitaciones: transformar los datos ------------------------
  targets::tar_target(
    transformar_datos_precipitaciones_valores_actuales,
    transformar_datos_precipitaciones_valores_actuales_func(procesar_datos_precipitaciones_valores_actuales,deptos_distritos_map)
  ),
  # 5. almacenar: ganaderia: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_ganaderia_valores_actuales,
    almacenar_datos_ganaderia_valores_actuales_func(transformar_datos_ganaderia_valores_actuales,config_valida)
  ),
  # 5.a almacenar: tambo: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_tambo_valores_actuales,
    almacenar_datos_tambo_valores_actuales_func(transformar_datos_tambo_valores_actuales,config_valida)
  ),
  # 5.b almacenar: porcinos: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_porcinos_valores_actuales,
    almacenar_datos_porcinos_valores_actuales_func(transformar_datos_porcinos_valores_actuales,config_valida)
  ),
  # 5.c almacenar: carne_ave: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_carne_ave_valores_actuales,
    almacenar_datos_carne_ave_valores_actuales_func(transformar_datos_carne_ave_valores_actuales,config_valida)
  ),
  # 5.d almacenar: huevo: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_huevo_valores_actuales,
    almacenar_datos_huevo_valores_actuales_func(transformar_datos_huevo_valores_actuales,config_valida)
  ),
  # 5.e almacenar: precipitaciones: almacenar los datos ------------------------
  targets::tar_target(
    almacenar_datos_precipitaciones_valores_actuales,
    almacenar_datos_precipitaciones_valores_actuales_func(transformar_datos_precipitaciones_valores_actuales,config_valida)
  ),
  # 6. disponibilizar ganaderia ------------------------
  targets::tar_target(
    disponibilizar_datos_ganaderia_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,config_valida)
    }
  ),
  # 6.a disponibilizar tambo ------------------------
  targets::tar_target(
    disponibilizar_datos_tambo_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_tambo_valores_actuales_func(almacenar_datos_tambo_valores_actuales,config_valida)
    }
  ),
  # 6.b disponibilizar porcinos ------------------------
  targets::tar_target(
    disponibilizar_datos_porcinos_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_porcinos_valores_actuales_func(almacenar_datos_porcinos_valores_actuales,config_valida)
    }
  ),
  # 6.c disponibilizar carne ave ------------------------
  targets::tar_target(
    disponibilizar_datos_carne_ave_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_carne_ave_valores_actuales_func(almacenar_datos_carne_ave_valores_actuales,config_valida)
    }
  ),
  # 6.d disponibilizar huevo ------------------------
  targets::tar_target(
    disponibilizar_datos_huevo_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_huevo_valores_actuales_func(almacenar_datos_huevo_valores_actuales,config_valida)
    }
  ),
  # 6.e disponibilizar precipitaciones ------------------------
  targets::tar_target(
    disponibilizar_datos_precipitaciones_valores_actuales,
    {
      url_valida_destino_recursos_url
      disponibilizar_datos_precipitaciones_valores_actuales_func(almacenar_datos_precipitaciones_valores_actuales,config_valida)
    }
  ),
  # 7. validar ganaderia ------------------------
  targets::tar_target(
    validar_disponible_datos_ganaderia_valores_actuales,
    validar_disponible_datos_ganaderia_valores_actuales_func(almacenar_datos_ganaderia_valores_actuales,disponibilizar_datos_ganaderia_valores_actuales,config_valida)
  ),
  # 7.a validar tambo ------------------------
  targets::tar_target(
    validar_disponible_datos_tambo_valores_actuales,
    validar_disponible_datos_tambo_valores_actuales_func(almacenar_datos_tambo_valores_actuales,disponibilizar_datos_tambo_valores_actuales,config_valida)
  ),
  # 7.b validar porcinos ------------------------
  targets::tar_target(
    validar_disponible_datos_porcinos_valores_actuales,
    validar_disponible_datos_porcinos_valores_actuales_func(almacenar_datos_porcinos_valores_actuales,disponibilizar_datos_porcinos_valores_actuales,config_valida)
  ),
  # 7.c validar huevo ------------------------
  targets::tar_target(
    validar_disponible_datos_huevo_valores_actuales,
    validar_disponible_datos_huevo_valores_actuales_func(almacenar_datos_huevo_valores_actuales,disponibilizar_datos_huevo_valores_actuales,config_valida)
  ),
  # 7.d validar carne_ave ------------------------
  targets::tar_target(
    validar_disponible_datos_carne_ave_valores_actuales,
    validar_disponible_datos_carne_ave_valores_actuales_func(almacenar_datos_carne_ave_valores_actuales,disponibilizar_datos_carne_ave_valores_actuales,config_valida)
  ),
  # 7.e validar precipitaciones ------------------------
  targets::tar_target(
    validar_disponible_datos_precipitaciones_valores_actuales,
    validar_disponible_datos_precipitaciones_valores_actuales_func(almacenar_datos_precipitaciones_valores_actuales,disponibilizar_datos_precipitaciones_valores_actuales,config_valida)
  ),

  # recordar que una web no tiene que procesar tiene que comer directamente lo mas posible.
  # todo lo que dependa de predios , va a estar agarrado de la app.
  # que son los predios pre cargados
  # puedo tratar de dejar todo eso pre calculado o solo actualizar el excel , eso a revisar.

  #8 calculo final del webscrap recursos: ------------------------
  targets::tar_target(
    valores_precios_webscrap_final,
    { # solo para declarar dependencia en grafo,
      validar_disponible_datos_precipitaciones_valores_actuales
      validar_disponible_datos_carne_ave_valores_actuales
      validar_disponible_datos_huevo_valores_actuales
      validar_disponible_datos_porcinos_valores_actuales
      validar_disponible_datos_tambo_valores_actuales
      validar_disponible_datos_ganaderia_valores_actuales

      # este es el que hace:
      valores_precios_webscrap_recursos_final_func(config_valida)
    }

  ),
  # 9.a informe final scraping ------------------------
  tarchetypes::tar_quarto(reporte_final,"reportes/webscrap_informe.qmd"),
  # 10 informe final scraping ------------------------
  targets::tar_target(reporte_final_upload,
                      {
                        url_valida_destino_informes_url
                        print(file.exists(reporte_final))
                        subir_informe_final(config_valida)
                        }
  )

)
