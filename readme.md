# Inta Web Scraping

el objetivo de este proyecto es extraer informacion web para disponiblizar para el proyecto de predios y buffers.
la idea es que la informacion se actualice sola en base a las diferentes paginas que tienen la misma.

# tareas

- determinar sitios de informacion a extraer
- obtener los datos crudos
- procesar los datos 
- almacenar los datos procesados
- disponibilizar los datos procesados en formato conveniente para la app.
- dejar el proceso corriendo todos los dias para tener la info actualizada.

-- dentro de la app: 
- actualizar los scripts para consultar los datos disponibilizados
- dejar un proceso que consuma los datos disponibles
- ver que la app se vean reflejados los cambios.

## tarea: determinar sitios de informacion a extraer

- fuente: https://miro.com/app/board/uXjVPWByCa0=/
- datos: 
 - actividades
  - ganaderia: precio ( scrap + actualizar calculo ), cantidad ( actualizar calculo)
  - tambo: precio ( scrap + actualizar calculo ), cantidad ( actualizar calculo)
  - huevo: precio ( scrap + actualizar calculo ), cantidad ( actualizar calculo)
  - carne de ave: precio ( scrap + actualizar calculo ), cantidad ( actualizar calculo)
  - porcino: precio ( scrap + actualizar calculo ), cantidad ( actualizar calculo)
 - perdida por lluvia:
  - nuevo dato: incorporar en la app
  
# caclulo de datos segun nuevos origenes: 

- para ganaderia: 
 - cantidad : (120.8458*predio)-(0.3*potrero)
  - predio: sale de la info de predios
  - potrero: sale de la info de predios
 - precio: (precio "terneros/as"* *175)
  - precio ternero/as: sale de la pagina de rosgan.
 - proceso ganaderia: 
  - el proyecto descrapping solo provee el precio de ternero/as de rosgan.
  - que diga: ganedria|indices_tabla|valores_tabla|indices_fecha
  
- para las cantidades en general , se usan datos de predios. no se calcula dentro del proceso de webscrap.
- se va a tener que hacer un refactor de la app para los calculos. 
- la seccion de webscrap solo va a generar el: "precio" de cada recurso.
- los calculos internos de la app cambian 
- foco en el scrap.
- luego revisar el calculo y caer con una propuesta a validar por mati


# cantidades: 

output final web scrap: 
porcinos: precio:  precio máximo capón
carne_ave: precio: Precio polla recriada blanca  18 meses
huevo: precio final: Precio polla recriada blanca 16 semanas
tambo: precio final: precio "vaca con garantia de preñez"
ganaderia: precio final: (precio "terneros/as"* *175)

en la app pre procesamiento de predios: 

ganaderia: cantidad: (120.8458*predio)-(0.3*potrero)
tambo: cantidad: 1.56+13.45409*predio
carne_ave: cantidad: 65,16*tinglado
porcinos: cantidad: 1 capon 1.51  metros de perímetro de tinglado

dudas: 

huevo: cantidad: cantidad gallinas =-3273+(77,722*tinglado)+(19276*automático) ( automático ? )

# consultas mati: 

- como tomamos las precipitaciones: porque vienen en formato diario , deberia ser promedio agrupado entre N dias, entre n estaciones pertenecientes por distrito > si el promedio supera los 20 mm , entonces penalizacion.

- tema cantidades de huevo, automatico ?? y esa variable de donde sale ???
