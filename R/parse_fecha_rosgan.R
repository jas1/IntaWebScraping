parse_fecha_rosgan <- function(p_str_fecha){
  # 14 de diciembre de 2023
  tmp_str <- p_str_fecha |> stringr::str_split(pattern = " de ",simplify = TRUE, n=3)

  # mes_fecha <- get_mes_segun_fecha(tmp_str[[2]])
  # dia_fecha <- get_dia_segun_fecha(tmp_str[[1]])
  # year_fecha <- get_anio_segun_fecha(tmp_str[[3]])

  mes_fecha <- get_mes_segun_fecha(tmp_str[[2]])
  print(mes_fecha)
  dia_fecha <- tmp_str[[1]]

  # CASO DE  DIA RARO: '8 y 9'
  if(stringr::str_detect(dia_fecha,pattern = "y" )){
    dia_fecha_split <- dia_fecha |> stringr::str_split(pattern = "y",simplify = TRUE, n=2) |> purrr::map_chr(stringr::str_trim)
    tmp_max <- as.integer(dia_fecha_split) |>  max()
    if(tmp_max<10){
      tmp_max <- paste0("0",tmp_max)
    }

    dia_fecha <- tmp_max
  }

  year_fecha <- tmp_str[[3]]

  # print(tmp_str)
  # print(tmp_str[[1]][[1]])
  # print(tmp_str[[2]][[1]])
  # print(tmp_str[[3]])

  str_fecha <- glue::glue("{year_fecha}-{mes_fecha}-{dia_fecha}")

  # p_str_fecha <- '14 de diciembre de 2022'
  # p_str_fecha <- '8 y 9 de diciembre de 2022'

  # str_fecha <- "2022-12-14"
  # str_fecha <- "2022-12-8 y 9"
  print(str_fecha)
  validar_fecha <- stringr::str_detect(str_fecha, "^\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])$")
  if(!eval(validar_fecha)) stop(deparse(validar_fecha), glue::glue(". Formato de fecha no reconocido.\n se espera 'dia_numero de mes_string de anio_numero'\n ejemplo: '14 de diciembre de 2022' , recibido: {p_str_fecha}"), call. = FALSE)

  str_fecha
}
