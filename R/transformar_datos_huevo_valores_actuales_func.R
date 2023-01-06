transformar_datos_huevo_valores_actuales_func <- function(df_procesado){
  # tambo sale del ave / huevo: formato df:
  # "descripcion"  "precio"       "fecha_semana"
  # Polla recriada de 16 semanas blanca - C/U	$ 997,50	REFERENCIA SEMANA DEL 02/01/2023
  # Polla recriada de 18 semanas blanca - C/U	$ 1.050,00	REFERENCIA SEMANA DEL 02/01/2023

  # descripcion=="Polla recriada de 16 semanas blanca" > explotacion=="huevo"
  # descripcion=="Polla recriada de 18 semanas blanca" > explotacion=="carne_ave"

  ret <- df_procesado |>
    dplyr::filter(stringr::str_detect(stringr::str_to_lower(descripcion),"polla recriada de 16 semanas blanca")) |>
    dplyr::mutate(indices_tabla=glue::glue("{descripcion} | {precio} | {fecha_semana}")) |>
    dplyr::mutate(indices_fecha=lubridate::dmy(fecha_semana)) |>
    dplyr::mutate(actualizado_fecha=lubridate::today()) |>
    dplyr::mutate(valores_tabla=readr::parse_number(precio,locale = readr::locale(decimal_mark = ","))) |>
    dplyr::mutate(explotacion="huevo") |>
    dplyr::mutate(origen="capia") |>
    dplyr::select(indices_tabla,indices_fecha,valores_tabla,explotacion,origen,actualizado_fecha)
  ret
}
