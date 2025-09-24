#!/bin/bash

# Definir flag -o utilizando getopts
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

# Entradas: recibe por stdin los datos (comm  cant  prom_cpu  max_cpu  prom_mem  max_mem)
# Salidas: escribe el reporte csv con metadatos en el archivo indicado por -o
# Descripción: agrega metadatos (# fecha, # usuario, # host) y convierte a csv
report() {
  {
    echo "# generated_at: $fecha"
    echo "# user: $usuario"
    echo "# host: $host"
    # Leer nombres del encabezado y poner comas para armar el csv
    read -r encabezado
    IFS=$'\t' read -ra col <<< "$encabezado"
    for i in "${!col[@]}"; do
      if [[ $i -eq 0 ]]; then
        printf '"%s"' "${col[$i]}"
      else
        printf ',"%s"' "${col[$i]}"
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
}
report