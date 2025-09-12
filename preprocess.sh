#!/bin/bash
#Entrada: lineas "pid uid comm pcpu pmem timestamp" por stdin
#Salida: mismas lineas validadas: si --iso8601 como primer argumento convierte timestamp a ISO8601
#Descripcion: valida el formato de los datos y convierte el timestamp si se solicita.

#Ayuda utilizando -h como primer argumento, 
usar_iso=false
case "$1" in --iso8601) usar_iso=true; shift ;; -h|--help)
 echo "--iso8601 como primer argumento si se quiere convertir timestamp a ISO8601"; exit 0 ;;"" ) ;; * ) 
 echo "flag no reconocida: $1 , usa -h como primer argumento" >&2; exit 1 ;;
esac

while read -r line; do
  read -r pid uid comm pcpu pmem timestamp <<< "$line"

  #Validaciones 
  [[ "$pid" =~ ^[0-9]+$ ]] || continue # pid entero
  [[ "$uid" =~ ^[0-9]+$ ]] || continue # uid entero
  [[ "$pcpu" =~ ^[0-9]+([.][0-9]+)?$ ]] || continue # pcpu decimal
  [[ "$pmem" =~ ^[0-9]+([.][0-9]+)?$ ]] || continue # pmem decimal
  [[ "$timestamp" =~ ^[0-9]+$ ]] || continue # timestamp entero

  if $usar_iso; then
    iso=$(date -d @"$timestamp" +"%Y-%m-%dT%H:%M:%S%z") || continue
    printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$pid" "$uid" "$comm" "$pcpu" "$pmem" "$iso"
  else
    printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$pid" "$uid" "$comm" "$pcpu" "$pmem" "$timestamp"
  fi
done
