:: /home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping
:: chron script:
:: chmod +x /home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/ejecutar_webscrap.sh

:: Rscript -e 'print(.libPaths());renv::run(project="/home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/",script="/home/julio/Dropbox/julio_box/trabajo/clientes/202208_inta_web_scraping/IntaWebScraping/tar_exec.R")'

:: para correr desde consola hace falta instalar el quarto CLI: https://quarto.org/docs/download/
:: rstudio , viene con uno , pero no vas a instalar el rstudio en un entorno prod.

@ECHO OFF
:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
   IF "%%~L"=="" goto s_done
      SET _yyyy=%%L
      SET _mm=00%%J
      SET _dd=00%%G
      SET _hour=00%%H
      SET _minute=00%%I
      SET _second=00%%K
)
:s_done

:: Pad digits with leading zeros
SET t_yyyy=%_yyyy%
SET t_mm=%_mm:~-2%
SET t_dd=%_dd:~-2%
SET t_hour=%_hour:~-2%
SET t_minute=%_minute:~-2%
SET t_second=%_second:~-2%

SET logtimestamp=%t_yyyy%%t_mm%%t_dd%_%t_hour%%t_minute%
goto make_dump

:s_error
echo WMIC no disponible, usando el default name
SET logtimestamp=_

:make_dump
SET FILENAME=log_webscrapt_%logtimestamp%.txt

SET current_path="C:/dev/IntaWebScraping"

SET LOG_FILE="C:/dev/tmp/%FILENAME%"

cd %current_path%
"C:/Program Files/R/R-4.2.3/bin/Rscript" "%current_path%/test.R" >>"%LOG_FILE%"
