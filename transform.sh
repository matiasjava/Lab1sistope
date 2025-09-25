#!/bin/bash

# Entrada: lineas "timestamp pid uid comm pcpu pmem" por stdin y como parametro --anon-uid
# Salida: las mismas lineas "timestamp pid uid comm pcpu pmem" pero con el uid anonimizado
# Descripcion: mostrar los procesos con el uid anonimizado

anon_uid() {
    # Verificar parametro
    if [ "$1" != "--anon-uid" ]; then
        echo "Error: Se debe pasar el parametro --anon-uid" >&2
        exit 1
    fi

    # Leer stdin linea por linea
    while read -r line; do
        local ts=$(echo "$line" | awk '{print $1}')      # timestamp
        local pid=$(echo "$line" | awk '{print $2}')     # pid
        local uid=$(echo "$line" | awk '{print $3}')     # uid original
        local comm=$(echo "$line" | awk '{print $4}')    # comando
        local pcpu=$(echo "$line" | awk '{print $5}')    # cpu
        local pmem=$(echo "$line" | awk '{print $6}')    # memoria

        # Anonimizar UID usando SHA-1
        local uid_hashed=$(echo -n "$uid" | sha1sum | awk '{print $1}')

        # Imprimir con UID anon
        echo -e "$ts\t$pid\t$uid_hashed\t$comm\t$pcpu\t$pmem"
    done
}

anon_uid "$@"




