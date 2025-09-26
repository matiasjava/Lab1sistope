Ejecucion del pipeline completo en la terminal:

Para ejecutar el pipeline completo se deben escribir los siguientes comandos en la terminal. la terminal se debe abrir dentro de la carpeta que contiene los scripts:

./generator.sh -i 1 -t 10 \
| ./preprocess.sh --iso8601 \
| ./filter.sh -c 10 -m 5 -r "^(firefox|code)$" \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte.csv

Ejemplos de uso con distintos parametros:

1) Ejecutar el pipeline capturando cada 1 segundo durante 5 segundos, convirtiendo timestamps a ISO8601 y filtrando procesos python y chrome.
En la terminal se debe escribir:

./generator.sh -i 1 -t 5 \
| ./preprocess.sh --iso8601 \
| ./filter.sh -c 3.5 -m 4.5 -r "^(python|chrome)$" \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte1.csv

2) Ejecutar el pipeline capturando cada 2 segundos durante 6 segundos, sin convertir timestamps y filtrando procesos firefox y code. (este el reporte final que se encuentra en la carpeta)
En la terminal se debe escribir:

./generator.sh -i 2 -t 6 \
| ./preprocess.sh \
| ./filter.sh -c 1 -m 1 -r "^(firefox|code)$" \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte2.csv

3) Ejecutar el pipeline capturando cada 1 segundo durante 8 segundos, sin filtrar por nombre de comando, solo aplicando filtro de CPU y MEM (procesos con CPU > 5 y MEM > 1). 
En la terminal se debe escribir:

./generator.sh -i 1 -t 8 \
| ./preprocess.sh \
| ./filter.sh -c 0.3 -m 1 \
| ./transform.sh --anon-uid \
| ./aggregate.sh \
| ./report.sh -o reporte3.csv

-------------------------------------------------------------------
Explicacion de anonimizar uid:
primero se verifica que se ingrese el parametro --anon-uid, luego 
se lee linea por linea por stdin y se extraen los valores de cada linea con awk.
la linea principal donde se ananomiza el uid es local uid_hashed=$(echo -n "$uid" | sha1sum | awk '{print $1}')
Donde echo -n "$uid" imprime el UID sin salto de línea, luego se ocupa el comando sha1sum, el cual calcula el hash SHA-1, donde este hash contiene 40 digitos.Por ultimo se selecciona solo el uid anonimizado con awk '{print $1}' y este es almacenado en la variable uid_hashed
