get_mes_segun_fecha <- function(p_str_mes){

  str_mes <- stringr::str_to_lower(p_str_mes)

  nombres_es <- c('enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre')
  nombres_en <- c('january','february','march','april','may','june','july','august','september','october','november','december')

  ret <- which(nombres_es==str_mes)  |> as.character() |> stringr::str_pad(width = 2,side = "left",pad="0")

  if(length(ret)==0){
    ret <- which(nombres_en==str_mes)  |> as.character() |> stringr::str_pad(width = 2,side = "left",pad="0")
  }

  ret
}
