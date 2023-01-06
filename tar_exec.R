library(targets)
targets::tar_make()
# para limpiar todas las tareas:  targets::tar_destroy(destroy = "all",ask = FALSE)
# para limpiar alguna en particular: targets::tar_delete("nombre")
