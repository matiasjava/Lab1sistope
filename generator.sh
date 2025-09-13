#!/bin/bash

# Almacenar los argumentos que se pasaron por terminal con sus respectivas flags
while getopts "i:t:" opt; do
  case $opt in
    i) intervalo=$OPTARG ;;
    t) tiempo_total=$OPTARG ;;
    *) 
      echo "Flag no reconocida: $OPTARG"
      exit 1
      ;;
  esac
done

# Validar que los argumentos se pasaron correctamente
if [[ -z "$intervalo" || -z "$tiempo_total" ]]; then
  echo "Debe especificar intervalo (-i) y tiempo total (-t)"
  exit 1
fi

# Calcular la cantidad de repeticiones
veces=$(( tiempo_total / intervalo ))


# Entradas: ninguna, obtiene los datos del sistema
# Salidas: lista de procesos por stdout con columnas pid, uid, comm, pcpu, pmem y timestamp Unix.
# Descripcion: obtiene todos los procesos del sistema, los ordena por CPU descendente y agrega un timestamp a cada linea.
imprimir_ps() {
  ps -eo pid=,uid=,comm=,pcpu=,pmem= --sort=-%cpu | while read -r pid uid comm pcpu pmem; do
    echo "$pid $uid $comm $pcpu $pmem $(date +%s)"
  done
}

# Ciclo for para ejecutar el comando ps -eo pid=,uid=,comm=,pcpu=,pmem= --sort=-%cpu
for ((c=1; c<=veces; c++)); do
  sleep "$intervalo"
  imprimir_ps
done




