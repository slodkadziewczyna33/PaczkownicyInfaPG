# Paczka Updater

### Ważne - przeczytać przed dodawaniem do paczki:
Kontrybucje do paczki:
1. Do każdego przedmiotu tworzymy brancha  
2. Po zakończeniu pracy wystawiamy PR  
3. Przynajmniej jedna osoba musi go zatwierdzić, żeby został przyjęty  
4. Po trafieniu do mastera jest automatycznie uploadowane na [gdrive](https://drive.google.com/drive/folders/1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv?usp=sharing)  

## Uwagi

- Puste foldery działają jak w githubie (nie są przesyłane). Jeżeli chcecie wysłać pusty folder, to stwórzcie plik ".gitkeep". Zostanie on usunięty automatycznie przed uploadem na gdrive.
- Odchudzić foldery ze wszystkich plików *.bin, *.proj etc. - w celu ułatwienia tego został stworzony [gitignore-generator](gitignores/gitignore-generator.sh). W celu zapoznania się z działaniem należy użyć flagi -h. Skrypt pozwala na szybkie generowanie .gitignore'ów i łączących różne technologie. Tak wygenerowany skrypt należy umieścić w folderze projektu, który jest wrzucany do paczki.  