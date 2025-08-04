#!/bin/bash

main_dir="test"
rm -rf "$main_dir"

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
    
    # Dodaj standardowe foldery
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
        current_semester=$(echo "$current_semester" | sed 's/ //; s/ //g')
        current_stream=""
        current_profile=""
        mkdir -p "$main_dir/$current_semester"
        
        # Dla semestrów 5, 6 i 7 tworzymy folder Wspolne
        if [[ "$current_semester" == "SEMESTR5" || "$current_semester" == "SEMESTR6" || "$current_semester" == "SEMESTR7" ]]; then
            mkdir -p "$main_dir/$current_semester/Wspolne"
        fi
        continue
    fi
    
    # Sprawdzamy czy to seminarium dyplomowe - specjalna obsługa
    if [[ "$line" =~ \(SDII\)_Seminarium_Dyplomowe_Inżynierskie_II ]]; then
        subject_code="SDII"
        subject_name="Seminarium_Dyplomowe_Inżynierskie_II"
        classes=$(echo "$line" | awk -F': ' '{print $2}')
        folder_name="(${subject_code})_${subject_name// /_}"
        full_path="${main_dir}/${current_semester}/Wspolne/${folder_name}"
        create_subject_folders "$full_path" "$classes"
        continue
    fi
    
    # SEMESTR7 - specjalna obsługa (pomijamy strumienie, tylko profile)
    if [[ "$current_semester" == "SEMESTR7" ]]; then
        # Sprawdzamy czy linia to profil
        if [[ "$line" =~ ^[[:space:]]*(.*)\ \(Profil\) ]]; then
            current_profile="${BASH_REMATCH[1]}"
            current_profile=$(echo "$current_profile" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            
            # Generowanie akronimu (K + pierwsze litery każdego słowa)
            profile_name=$current_profile
            acronym="K"
            for word in $profile_name; do
                first_char=$(echo "${word:0:1}" | tr '[:lower:]' '[:upper:]')
                acronym="${acronym}${first_char}"
            done
            
            # Formatowanie nazwy z podkreśleniami
            formatted_name=$(echo "$profile_name" | sed -E 's/(^| )([a-z])/\1\u\2/g' | tr ' ' '_')
            
            current_profile="(${acronym})_${formatted_name}"
            mkdir -p "$main_dir/$current_semester/$current_stream/$current_profile"
            continue
        fi
        
        # Sprawdzamy czy linia to przedmiot (zaczyna się od nawiasu)
        if [[ "$line" =~ ^[[:space:]]*\( ]]; then
            subject_code=$(echo "$line" | sed -E 's/^[[:space:]]*\(([^)]*)\).*/\1/')
            subject_name=$(echo "$line" | sed -E 's/^[[:space:]]*\([^)]*\)_(.*):.*/\1/' | tr '_' ' ')
            classes=$(echo "$line" | awk -F': ' '{print $2}')
            folder_name="(${subject_code})_${subject_name// /_}"
            
            if [[ -n "$current_profile" ]]; then
                full_path="${main_dir}/${current_semester}/${current_profile}/${folder_name}"
            else
                full_path="${main_dir}/${current_semester}/Wspolne/${folder_name}"
            fi

            create_subject_folders "$full_path" "$classes"
        fi
        continue
    fi
    
    # Dla pozostałych semestrów normalna obsługa
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
        subject_code=$(echo "$line" | sed -E 's/^[[:space:]]*\(([^)]*)\).*/\1/')
        subject_name=$(echo "$line" | sed -E 's/^[[:space:]]*\([^)]*\)_(.*):.*/\1/' | tr '_' ' ')
        classes=$(echo "$line" | awk -F': ' '{print $2}')
        folder_name="(${subject_code})_${subject_name// /_}"
        
        if [[ -n "$current_profile" ]]; then
            full_path="${main_dir}/${current_semester}/${current_stream}/${current_profile}/${folder_name}"
        elif [[ -n "$current_stream" ]]; then
            full_path="${main_dir}/${current_semester}/${current_stream}/${folder_name}"
        else
            if [[ "$current_semester" == "SEMESTR5" || "$current_semester" == "SEMESTR6" || "$current_semester" == "SEMESTR7" ]]; then
                full_path="${main_dir}/${current_semester}/Wspolne/${folder_name}"
            else
                full_path="${main_dir}/${current_semester}/${folder_name}"
            fi
        fi

        create_subject_folders "$full_path" "$classes"
    fi
done < "$1"

echo "Struktura folderów została utworzona."