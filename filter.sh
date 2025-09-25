#!/bin/bash

#!/bin/bash
# Entradas: lineas "timestamp pid uid comm pcpu pmem" por stdin y los parametros -c cpu_min o/y -m mem_min o/y -r regex 
# Salidas: las lineas "timestamp pid uid comm pcpu pmem" filtradas por los parametros de entrada
# Descripcion: filtrar los procesos segun un cpu_min y/o mem_min o/y regex

filter() {
    cpu_min=""
    mem_min=""
    regex=""

    # Leer los parámetros
    while getopts "c:m:r:" opt; do
        case "$opt" in
            c) cpu_min="$OPTARG" ;;
            m) mem_min="$OPTARG" ;;
            r) regex="$OPTARG" ;;
            *) echo "Opción inválida" >&2; exit 1 ;;
        esac
    done

    # Verificar que al menos un filtro se haya pasado
    if [ -z "$cpu_min" ] && [ -z "$mem_min" ] && [ -z "$regex" ]; then
        echo "Error: debes pasar al menos un filtro (-c, -m o -r)" >&2
        exit 1
    fi

    # Validar que cpu_min y mem_min sean números positivos
    if [ -n "$cpu_min" ] && ! [[ "$cpu_min" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: -c debe ser un número entero o decimal positivo" >&2
        exit 1
    fi
    if [ -n "$mem_min" ] && ! [[ "$mem_min" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: -m debe ser un número entero o decimal positivo" >&2
        exit 1
    fi

    # Filtrado con awk
    awk -v cpu="$cpu_min" -v mem="$mem_min" -v reg="$regex" '
    {
        cond=1
        if (cpu != "") cond = cond && ($5 >= cpu)   # pcpu
        if (mem != "") cond = cond && ($6 >= mem)   # pmem
        if (reg != "") cond = cond && ($4 ~ reg)    # comm
        if (cond) print $0
    }'
}

filter "$@"
