Ejecucion del pipeline completo en la terminal:

Para ejecutar el pipeline completo se deben escribir los siguientes comandos en la terminal, dentro de la carpeta que contiene los scripts:

./generator.sh -i 1 -t 10 \
| ./preprocess.sh --iso8601 \
| ./filter.sh -c 10 -m 5 -r "^(firefox|code)$" \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte.tsv

Ejemplos de uso con distintos parametros:

1) Ejecutar el pipeline capturando cada 1 segundo durante 5 segundos, convirtiendo timestamps a ISO8601 y filtrando procesos python y chrome. 
En la terminal se debe escribir:

./generator.sh -i 1 -t 5 \
| ./preprocess.sh --iso8601 \
| ./filter.sh -c 5 -m 2 -r "^(python|chrome)$" \
| ./transform.sh \
| ./aggregate.sh \
| ./report.sh -o reporte1.tsv

2) Ejecutar el pipeline capturando cada 2 segundos durante 6 segundos, sin convertir timestamps y filtrando procesos firefox y code. 
En la terminal se debe escribir:

./generator.sh -i 2 -t 6 \
| ./preprocess.sh \
| ./filter.sh -c 0 -m 0 -r "^(firefox|code)$" \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte2.tsv

3) Ejecutar el pipeline capturando cada 1 segundo durante 8 segundos, sin filtrar por nombre de comando, solo aplicando filtro de CPU y MEM (procesos con CPU > 5 y MEM > 1). 
En la terminal se debe escribir:

./generator.sh -i 1 -t 8 \
| ./preprocess.sh \
| ./filter.sh -c 5 -m 1 \
| ./transform.sh \
| ./aggregate.sh \
| ./report.sh -o reporte3.tsv
