#!/bin/bash

# Definir flag -o y argumento
while getopts "o:" opt; do
  case $opt in o) outfile="$OPTARG"  ;; *)
      echo "Tienes que usar -o: $0 -o archivo.csv" >&2
      exit 1
      ;;
  esac
done

# Verificar que se haya proporcionado el argumento -o
if [[ -z "$outfile" ]]; then
  echo "Falta el nombre del archivo de salida (-o)" >&2
  exit 1
fi

# Obtener metadatos
fecha=$(date -Iseconds) # -Iseconds para obtener segundos en el formato ISO 8601
usuario=$(whoami)
host=$(hostname)

# Escribir metadatos al principio
{
  echo "# generated_at: $fecha"
  echo "# user: $usuario"
  echo "# host: $host"
  # Leer encabezado y poner comas para armar el csv
  read -r encabezado
  IFS=$'\t' read -ra cols <<< "$encabezado"
  for i in "${!cols[@]}"; do
    if [[ $i -eq 0 ]]; then
      printf '"%s"' "${cols[$i]}"
    else
      printf ',"%s"' "${cols[$i]}"
    fi
  done
  printf '\n'
  # leer los datos (comm, cant, prom_cpu, max_cpu, prom_mem, max_mem) y poner comas
  while IFS=$'\t' read -r -a fila; do
    for j in "${!fila[@]}"; do
      if [[ $j -eq 0 ]]; then
        printf '"%s"' "${fila[$j]}"
      else
        printf ',"%s"' "${fila[$j]}"
      fi
    done
    printf '\n'
  done
} > "$outfile"
