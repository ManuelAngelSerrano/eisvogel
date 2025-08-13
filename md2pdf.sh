#!/bin/bash

pandoc "$1" \
    --template eisvogel \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -o "$2"
