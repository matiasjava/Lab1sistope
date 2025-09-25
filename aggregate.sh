#!/bin/bash


#Entrada: pid uid comm pcpu pmem timestamp
#Salida: comm  cant  prom_cpu  max_cpu  prom_mem  max_mem
#Descripción: Agrupa por "comm", calcula cantidad, promedios y máximos de CPU/MEM.
aggregate() {
  awk '
    BEGIN {
      FS = "[ \t]+"; # Separador
      print "command\tnproc\tcpu_avg\tcpu_max\tmem_avg\tmem_max"; # Nombre de columnas
    }
  {
    c = $4 # se toma el tercer arumento para agrupar por comm
    cpu = $5 + 0 # cpu , el +0 es para forzar a numero
    mem = $6 + 0 # memoria
    n[c] = n[c] + 1 # cantidad de procesos
    sum_cpu[c] = sum_cpu[c] + cpu # suma de cpu
    sum_mem[c] = sum_mem[c] + mem # suma de memoria
    if (cpu > max_cpu[c] || n[c] == 1) max_cpu[c] = cpu  # revisa si cpu es mayor al maximo actual o si es el primer proceso
    if (mem > max_mem[c] || n[c] == 1) max_mem[c] = mem  # revisa si mem es mayor al maximo actual o si es el primer proceso
  }
  END {
    for (x in n) {
      prom_cpu = sum_cpu[x] / n[x] # calcula promedio cpu
      prom_mem = sum_mem[x] / n[x] # calcula promedio memoria
      printf "%s\t%d\t%.2f\t%.2f\t%.2f\t%.2f\n", x, n[x], prom_cpu, max_cpu[x], prom_mem, max_mem[x]
    }
  }
'
}

aggregate