#!/bin/bash

# Verificar que se paso el parametro
if [ "$1" != "--anon-uid" ]; then
    echo "Error: Se debe pasar el parametro --anon-uid"
    exit 1
fi

# Leer la entrada con stdin
while read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    uid=$(echo "$line" | awk '{print $2}')
    comm=$(echo "$line" | awk '{print $3}')
    pcpu=$(echo "$line" | awk '{print $4}')
    pmem=$(echo "$line" | awk '{print $5}')
    ts=$(echo "$line" | awk '{print $6}')

    # Anonimizar UID usando SHA-1
    uid_hashed=$(echo -n "$uid" | sha1sum | awk '{print $1}')

    # Imprimir con UID anon
    echo -e "$pid\t$uid_hashed\t$comm\t$pcpu\t$pmem\t$ts"
done


