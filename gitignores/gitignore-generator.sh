#!/bin/bash

GITHUB_REPO="https://raw.githubusercontent.com/github/gitignore/main"
TEMP_FILE=".gitignore.temp"
OUTPUT_FILE=".gitignore"

declare -A OPTIONS=(
    [1]="C"
    [2]="C++"
    [3]="CSharp"
    [4]="Java"
    [5]="Python"
    [6]="Node"
    [7]="JetBrains"
    [8]="Eclipse"
    [9]="VSCode"
    [10]="Unity"
    [11]="Go"
    [12]="Rust"
    [13]="Docker"
    [14]="Linux"
)

echo "🔧 Wybierz składniki do dodania do .gitignore (spacja = wybór, Enter = koniec):"

# Wyświetl menu
for i in "${!OPTIONS[@]}"; do
    printf "%2s) %s\n" "$i" "${OPTIONS[$i]}"
done

# Pobierz wybory
read -p "Wprowadź numery oddzielone spacją: " -a SELECTION

# Stwórz/wyczyść plik tymczasowy
> "$TEMP_FILE"

# Pobierz odpowiednie pliki
for index in "${SELECTION[@]}"; do
    OPTION="${OPTIONS[$index]}"
    if [ -n "$OPTION" ]; then
        URL="$GITHUB_REPO/${OPTION}.gitignore"
        echo "🌍 Pobieram ${OPTION}.gitignore..."
        curl -fsSL "$URL" >> "$TEMP_FILE" && echo -e "\n# --------- ${OPTION}.gitignore kończy się tutaj ---------\n" >> "$TEMP_FILE" || echo "⚠️  Błąd pobierania: $OPTION"
    else
        echo "⚠️  Nieprawidłowy numer: $index"
    fi
done

# Gotowy plik
mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "✅ Wygenerowano $OUTPUT_FILE z wybranych komponentów."
