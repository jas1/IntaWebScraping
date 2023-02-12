
library(targets)
library(quarto)
targets::tar_destroy(destroy = "all",ask = FALSE)
targets::tar_make()

# targets::tar_delete("transformar_datos_precipitaciones_valores_actuales")
# targets::tar_make("validar_disponible_datos_ganaderia_valores_actuales")
# targets::tar_make("transformar_datos_ganaderia_valores_actuales")

# targets::tar_load("almacenar_datos_ganaderia_valores_actuales")

# targets::tar_read("transformar_datos_precipitaciones_valores_actuales")
# para limpiar todas las tareas:  targets::tar_destroy(destroy = "all",ask = FALSE)
# para limpiar alguna en particular: targets::tar_delete("nombre")
