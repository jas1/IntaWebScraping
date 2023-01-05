validar_crear_path_guardar <- function(output_dir1) {
  result <- is.character(output_dir1)
  if (!fs::dir_exists (output_dir1)){
    print(glue::glue("directorio inexistente: creando directorio: {output_dir1}"))
    fs::dir_create(output_dir1,recurse = TRUE)
  }
  result <- result & fs::dir_exists(output_dir1)
  result
}
