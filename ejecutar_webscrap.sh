# /home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping
# chron script:
# chmod +x /home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/ejecutar_webscrap.sh

# Rscript -e 'print(.libPaths());renv::run(project="/home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/",script="/home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/tar_exec.R")'

# para correr desde consola hace falta instalar el quarto CLI: https://quarto.org/docs/download/
# rstudio , viene con uno , pero no vas a instalar el rstudio en un entorno prod.

current_path="/home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping"

LOG_FILE="/tmp/log_webscrapt_$(date +\%Y\%m\%d_\%H\%M\%S).txt"

cd ${current_path}
Rscript "${current_path}/tar_exec.R" >>"${LOG_FILE}"
