#!/bin/bash
# Entrada: lineas "timestamp pid uid comm pcpu pmem" por stdin
# Salida: mismas lineas validadas; si --iso8601 se convierte timestamp a ISO8601
# Descripcion: valida el formato de los datos y convierte el timestamp si se solicita.

preprocess() {
  usar_iso=false
  case "$1" in 
    --iso8601) usar_iso=true; shift ;; 
    "" ) ;; 
    * ) echo "flag no reconocida: $1 , usa --iso8601 como primer argumento" >&2; exit 1 ;; # validacion de flag correcta
  esac

  # leer linea por linea de stdin
  while read -r line; do
    read -r timestamp pid uid comm pcpu pmem <<< "$line"

    # Validaciones
    [[ "$timestamp" =~ ^[0-9]+$ ]] || continue  # timestamp entero       
    [[ "$pid" =~ ^[0-9]+$ ]] || continue  # pid entero
    [[ "$uid" =~ ^[0-9]+$ ]] || continue  # uid entero
    [[ "$pcpu" =~ ^[0-9]+([.][0-9]+)?$ ]] || continue  # pcpu decimal
    [[ "$pmem" =~ ^[0-9]+([.][0-9]+)?$ ]] || continue  # pmem decimal

    # Comprobar si se uso --iso8601
    if $usar_iso; then
      iso=$(date -d @"$timestamp" +"%Y-%m-%dT%H:%M:%S%z") || continue
      printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$iso" "$pid" "$uid" "$comm" "$pcpu" "$pmem"  # se escribe la linea con timestamp en ISO8601
    else
      printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$timestamp" "$pid" "$uid" "$comm" "$pcpu" "$pmem" # se escribe la linea original
    fi
  done
}

preprocess "$@"

