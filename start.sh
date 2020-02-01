#!/bin/sh
case "${1}" in
  version )
    echo "stage: ${1}"
    clamscan --version
    clamconf | sed -ne '/Database information/,/^$/p'
    ;;
  scan )
    echo "stage: ${1}"
    echo "Starting Scan of /data:"
    clamscan -ir /data
    ;;
  * )
    echo "stage: ${1}"
    echo "Usage:"
    clamscan --help | head -n 20
    /bin/sh
    ;;
esac
