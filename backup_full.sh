#!/bin/bash

show_help() {
  cat <<EOF
Script Grupo 6 junio 2025 Uso: $(basename "$0") <origen> <destino>

<origen>   Directorio a respaldar (debe existir).
<destino>  Directorio o ruta completa del archivo .tar.gz donde se guardará
           el backup. Si es un directorio, el script creará
           <nombre_origen>_bkp_YYYYMMDD.tar.gz dentro de ese directorio.
EOF
  exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
fi

if (( $# != 2 )); then
  echo "Error: se requieren 2 argumentos." >&2
  show_help
fi

ORIGEN="$1"
DESTINO="$2"
DATE=$(date +%Y%m%d)

# "El script debe validar que los sistemas de archivos de origen y destino estén disponibles antes de ejecutar el backup."

if [[ ! -d "$ORIGEN" ]]; then
  echo "Error: origen inválido." >&2
  exit 1
fi

# archivo destino
if [[ -d "$DESTINO" ]]; then
  BASE=$(basename "$ORIGEN")
  DESTFILE="$DESTINO/${BASE}_bkp_${DATE}.tar.gz"
else
  DESTDIR=$(dirname "$DESTINO")
  if [[ ! -d "$DESTDIR" ]] || ! mountpoint -q "$DESTDIR"; then
    echo "Error: directorio destino inválido." >&2
    exit 2
  fi
  DESTFILE="$DESTINO"
fi

# hacer backup
tar -czf "$DESTFILE" -C "$(dirname "$ORIGEN")" "$(basename "$ORIGEN")" || {
  echo "Error durante el backup." >&2
  exit 3
}

exit 0
