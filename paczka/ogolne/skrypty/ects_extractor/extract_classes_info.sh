#!/bin/bash

input_file="struktura.txt"
output_file="przedmioty.txt"

# Czyszczenie pliku wyjściowego
> "$output_file"

# Ekstrakcja danych
awk -v output="$output_file" '
BEGIN {
    RS="<div class=\"data-table__row\">"
    FS="\n"
    semestr=0
}
function capitalize(str) {
    split(str, words, "_")
    result = ""
    for (i in words) {
        if (words[i] != "") {
            first = toupper(substr(words[i], 1, 1))
            rest = substr(words[i], 2)
            if (i > 1) result = result "_"
            result = result first rest
        }
    }
    return result
}
function get_acronym(subject) {
    # Zamień spacje na podkreślenia
    gsub(/ /, "_", subject)
    # Usuń podwójne podkreślenia
    gsub(/__/, "_", subject)
    # Wygeneruj akronim
    split(subject, words, "_")
    acronym = ""
    for (i in words) {
        if (words[i] != "") {
            acronym = acronym substr(words[i], 1, 1)
        }
    }
    capitalized = capitalize(subject)
    return "(" toupper(acronym) ")_" capitalized
}
/<strong>Semestr: [0-9]/ {
    match($0, /Semestr: ([0-9])/, arr)
    semestr=arr[1]
    printf "[Semestr %s]\n", semestr >> output
}
semestr > 0 {
    # Wyciągnij nazwę przedmiotu
    if (match($0, /<span class="cell__inner">([^<]+)<\/span>/, name)) {
        subject = name[1]
        # Pomijaj nagłówki i stopki
        if (subject !~ /ECTS|Suma punktów|Liczba godzin|Karta przedmiotu|WYCHOWANIE FIZYCZNE|PROJEKT GRUPOWY/) {
            # Wyciągnij komponenty
            split($0, lines, "<span class=\"cell__inner\">|</span>")
            w = c = l = p = s = ""
            for (i=2; i<=length(lines); i+=2) {
                val = lines[i]
                gsub(/^[ \t-]+|[ \t-]+$/, "", val)
                if (val == "") val = "-"
                
                if (i == 4) { ects = val }
                else if (i == 6) { w = val }
                else if (i == 8) { c = val }
                else if (i == 10) { l = val }
                else if (i == 12) { p = val }
                else if (i == 14) { s = val }
            }
            
            # Generuj akronim i formatuj nazwę
            formatted_subject = get_acronym(subject)
            
            # Formatuj wynik - tylko skróty dla wartości różnych od "-"
            output_line = formatted_subject ":"
            if (w != "-") output_line = output_line " W"
            if (c != "-") output_line = output_line " C" 
            if (l != "-") output_line = output_line " L"
            if (p != "-") output_line = output_line " P"
            if (s != "-") output_line = output_line " S"
            
            # Usuń potencjalne podwójne spacje
            gsub(/  +/, " ", output_line)
            print output_line >> output
        }
    }
}
END {
    print "\nDane zostały zapisane do pliku " output
}
' "$input_file"