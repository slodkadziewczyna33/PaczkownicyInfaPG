#!/bin/bash

url="https://ects.pg.edu.pl/pl/courses/15450/plan.xls"
output_file="struktura.txt"
curl -s "$url" > "$output_file"
ssconvert -S struktura.xls struktura.csv