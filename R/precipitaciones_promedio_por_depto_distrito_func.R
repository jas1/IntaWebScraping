precipitaciones_promedio_por_depto_distrito_func <- function(df_transform_precipitaciones) {
  resu <- df_transform_precipitaciones |>
    # dplyr::filter(departamento=="Paraná") |> # por ahora el unico mapeado.
    dplyr::group_by(departamento,distrito) |>
    dplyr::summarise(mm_pp_avg=dplyr::if_else(is.nan(mean(valores_tabla,na.rm=TRUE)),
                                              NA_real_,
                                              round(mean(valores_tabla,na.rm=TRUE),2)) )
  resu
}
