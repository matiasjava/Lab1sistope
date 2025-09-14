#!/bin/bash

cpu_min=""
mem_min=""
regex=""

# Almacenar los datos
while getopts "c:m:r:" opt; do
    case "$opt" in
        c) cpu_min="$OPTARG" ;;
        m) mem_min="$OPTARG" ;;
        r) regex="$OPTARG" ;;
        *) echo "Opcion invalida"; exit 1 ;;
    esac
done

# Verificar que todos los filtros se pasaron
if [ -z "$cpu_min" ] || [ -z "$mem_min" ] || [ -z "$regex" ]; then
    echo "Error: debes pasar todos los filtros -c CPU_MIN -m MEM_MIN -r REGEX"
    exit 1
fi

# Filtrado con awk
awk -v cpu="$cpu_min" -v mem="$mem_min" -v reg="$regex" '
{
    if ($4 >= cpu && $5 >= mem && $3 ~ reg)
        print $0
}'

