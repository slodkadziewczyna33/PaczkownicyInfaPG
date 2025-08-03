#!/bin/bash

url="https://ects.pg.edu.pl/pl/courses/15450/subjects"
output_file="struktura.txt"

# Wymaga: sudo apt install html-xml-utils
curl -s "$url" | hxnormalize -x | hxselect -c "div.mb-5" > "$output_file"

# Sprawdzenie wyniku
[ -s "$output_file" ] && echo "SUKCES" || echo "BŁĄD: Zainstaluj html-xml-utils"