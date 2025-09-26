#!/bin/bash

# Entradas: ninguna, obtiene los datos del sistema
# Salidas: lista de procesos por stdout con columnas timestamp, pid, uid, comm, pcpu, pmem
# Descripcion: obtiene todos los procesos del sistema, los ordena por CPU descendente y agrega un timestamp al inicio de cada linea.

imprimir_ps() {
  ts=$(date +%s)  # Obtener timestamp actual en segundos
  ps -eo pid=,uid=,comm=,pcpu=,pmem= --sort=-%cpu | while read -r pid uid comm pcpu pmem; do
    echo "$ts $pid $uid $comm $pcpu $pmem"  # Imprime una linea con timestamp seguido de los campos de ps
  done
}

# Entradas: parametros -i intervalo -t tiempo_total
# Salidas: lineas "timestamp pid uid comm pcpu pmem"
# Descripcion: obtiene los procesos del sistema, ordena por CPU y agrega timestamp.

generator() {
  # Leer los parametros y almacenarlos en variables
  while getopts "i:t:" opt; do
    case $opt in
      i) intervalo=$OPTARG ;;
      t) tiempo_total=$OPTARG ;;
      *) 
        echo "Flag no reconocida: $opt" >&2
        exit 1
        ;;
    esac
  done

  # Validar que se entreguen ambos parametros
  if [[ -z "$intervalo" || -z "$tiempo_total" ]]; then
    echo "Debe especificar intervalo (-i) y tiempo total (-t)" >&2
    exit 1
  fi

  # validar que ambos parametros sean enteros positivos
  if ! [[ "$intervalo" =~ ^[0-9]+$ && "$tiempo_total" =~ ^[0-9]+$ ]]; then
    echo "Los parametros -i y -t deben ser enteros positivos" >&2
    exit 1
  fi

  # validar que ambos parametros sean mayor a 0
  if [[ "$intervalo" -eq 0 || "$tiempo_total" -eq 0 ]]; then
    echo "Los parametros -i y -t deben ser mayores que 0" >&2
    exit 1
  fi

  # Calcular cuantas veces se repetira el comando ps
  # el + 1 es para que se cuente la ejecucion partiendo del tiempo = 0
  veces=$(( tiempo_total / intervalo + 1 ))

  # Ciclo de captura de los procesos
  for ((c=0; c<veces; c++)); do
    if [[ $c -ne 0 ]]; then
      sleep "$intervalo"
    fi
    imprimir_ps
  done
}


generator "$@"



