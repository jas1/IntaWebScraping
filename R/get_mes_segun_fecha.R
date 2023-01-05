get_mes_segun_fecha <- function(p_str_fecha){

  str_mes <- stringr::str_to_lower(p_str_fecha)

  nombres <- c('enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre')

  ret <- which(nombres==p_str_fecha)  |> as.character() |> stringr::str_pad(width = 2,side = "left",pad="0")

  ret
}
