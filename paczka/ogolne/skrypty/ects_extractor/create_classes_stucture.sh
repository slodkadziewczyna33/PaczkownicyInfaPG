#!/bin/bash

main_dir="test"

# Funkcja tworząca odpowiednie foldery dla przedmiotu
create_subject_folders() {
    local subject_dir="$1"
    local classes="$2"
    
    mkdir -p "$subject_dir"
    echo "Creating folders for subject: $subject_dir"

    if [[ "$classes" == *"W"* ]]; then
        mkdir -p "$subject_dir/wykład"
    fi
    if [[ "$classes" == *"C"* ]]; then
        mkdir -p "$subject_dir/ćwiczenia"
        mkdir -p "$subject_dir/kolokwia"
    fi
    if [[ "$classes" == *"L"* ]]; then
        mkdir -p "$subject_dir/laboratoria"
    fi
    if [[ "$classes" == *"P"* ]]; then
        mkdir -p "$subject_dir/projekt"
    fi
    if [[ "$classes" == *"S"* ]]; then
        mkdir -p "$subject_dir/seminarium"
    fi
    
    # Dodaj standardowe foldery, które mogą być potrzebne
    mkdir -p "$subject_dir/egzamin"
    mkdir -p "$subject_dir/opracowania"
    mkdir -p "$subject_dir/inne/książki"
    mkdir -p "$subject_dir/stara_paczka"
}

# Główna pętla przetwarzająca plik
current_semester=""
current_stream=""
current_profile=""
while IFS= read -r line; do
    # Pomijamy puste linie
    if [[ -z "$line" ]]; then
        continue
    fi
    
    # Sprawdzamy czy linia to nowy semestr
    if [[ "$line" =~ ^SEMESTR ]]; then
        current_semester="$line"
        current_semester=$(echo "$current_semester" | sed 's/ //; s/ //g')  # Usuwamy "SEMESTR" i spacje
        current_stream=""
        current_profile=""
        mkdir -p "$main_dir/$current_semester"
        continue
    fi
    
    # Sprawdzamy czy linia to strumień
    if [[ "$line" =~ ^[[:space:]]*(.*)\ \(Strumień\) ]]; then
        current_stream="${BASH_REMATCH[1]}"
        current_stream=$(echo "$current_stream" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        current_profile=""
        mkdir -p "$main_dir/$current_semester/$current_stream"
        continue
    fi
    
    # Sprawdzamy czy linia to profil
    if [[ "$line" =~ ^[[:space:]]*(.*)\ \(Profil\) ]]; then
        current_profile="${BASH_REMATCH[1]}"
        current_profile=$(echo "$current_profile" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        mkdir -p "$main_dir/$current_semester/$current_stream/$current_profile"
        continue
    fi
    
    # Sprawdzamy czy linia to przedmiot (zaczyna się od nawiasu)
    if [[ "$line" =~ ^[[:space:]]*\( ]]; then
        # Wyciągamy skrót przedmiotu i nazwę
        subject_code=$(echo "$line" | sed -E 's/^[[:space:]]*\(([^)]*)\).*/\1/')
        subject_name=$(echo "$line" | sed -E 's/^[[:space:]]*\([^)]*\)_(.*):.*/\1/' | tr '_' ' ')
        classes=$(echo "$line" | awk -F': ' '{print $2}')
        
        # Tworzymy nazwę folderu
        folder_name="(${subject_code})_${subject_name// /_}"
        
        # Tworzymy pełną ścieżkę
        if [[ -n "$current_profile" ]]; then
            full_path="${main_dir}/${current_semester}/${current_stream}/${current_profile}/${folder_name}"
        elif [[ -n "$current_stream" ]]; then
            full_path="${main_dir}/${current_semester}/${current_stream}/${folder_name}"
        else
            full_path="${main_dir}/${current_semester}/${folder_name}"
        fi

        # Tworzymy foldery
        create_subject_folders "$full_path" "$classes"
    fi
done < "$1"

echo "Struktura folderów została utworzona."