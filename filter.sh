#!/bin/bash

# Entradas: lineas "timestamp pid uid comm pcpu pmem" por stdin y los parametros -c cpu_min -m mem_min o/y -r regex 
# Salidas: las lineas "timestamp pid uid comm pcpu pmem" filtradas por los parametros de entrada
# Descripcion: filtrar los procesos segun cpu_min y mem_min, con regex opcional

filter() {
    cpu_min=""
    mem_min=""
    regex=""

    # Leer los parametros y almacenarlos en las variables
    while getopts "c:m:r:" opt; do
        case "$opt" in
            c) cpu_min="$OPTARG" ;;
            m) mem_min="$OPTARG" ;;
            r) regex="$OPTARG" ;;
            *) echo "Opcion invalida" >&2; exit 1 ;;
        esac
    done

    # Verificar que cpu_min y mem_min sean obligatorios
    if [ -z "$cpu_min" ] || [ -z "$mem_min" ]; then
        echo "Error: debes pasar al menos -c y -m" >&2
        exit 1
    fi

    # Validar que cpu_min y mem_min sean numeros positivos
    if ! [[ "$cpu_min" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: -c debe ser un numero entero o decimal positivo" >&2
        exit 1
    fi
    if ! [[ "$mem_min" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: -m debe ser un numero entero o decimal positivo" >&2
        exit 1
    fi

    # Filtrado con awk
    awk -v cpu="$cpu_min" -v mem="$mem_min" -v reg="$regex" '
    {
        cond = ($5 >= cpu) && ($6 >= mem)   # pcpu >= cpu_min Y pmem >= mem_min
        if (reg != "") cond = cond && ($4 ~ reg)    # si se entrego regex, se filtra que $4 coincida con el parametro
        if (cond) print $0
    }'
}

filter "$@"

