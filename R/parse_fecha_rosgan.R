parse_fecha_rosgan <- function(p_str_fecha){
  # 14 de diciembre de 2023
  tmp_str <- p_str_fecha |> stringr::str_split(pattern = " de ",simplify = TRUE, n=3)

  # mes_fecha <- get_mes_segun_fecha(tmp_str[[2]])
  # dia_fecha <- get_dia_segun_fecha(tmp_str[[1]])
  # year_fecha <- get_anio_segun_fecha(tmp_str[[3]])

  mes_fecha <- get_mes_segun_fecha(tmp_str[[2]])
  print(mes_fecha)
  dia_fecha <- tmp_str[[1]]
  year_fecha <- tmp_str[[3]]

  # print(tmp_str)
  # print(tmp_str[[1]][[1]])
  # print(tmp_str[[2]][[1]])
  # print(tmp_str[[3]])

  str_fecha <- glue::glue("{year_fecha}-{mes_fecha}-{dia_fecha}")
  print(str_fecha)
  str_fecha
}
