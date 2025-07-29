import os
import sys
import pathlib
from gdrive_auth import Create_Service
from gdrive_utility import get_existing_files_in_folder, upload_file

OAUTH2_SECRET = 'credentials.json'
SCOPES = ['https://www.googleapis.com/auth/drive']
API_TYPE = 'drive'
API_VERSION = 'v3'

LOCAL_FOLDER = 'paczka'
GDRIVE_FOLDER_ID = '1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv'

# Add the current file's directory (where gdrive_utility.py is) to sys.path
sys.path.append(os.path.dirname(__file__))

# Authenticate and build the Drive service
drive_service = Create_Service(
    OAUTH2_SECRET, API_TYPE, API_VERSION, SCOPES
)

def main():
    if not os.path.isdir(LOCAL_FOLDER):
        print(f"Folder '{LOCAL_FOLDER}' not found.")
        return

    existing_files = get_existing_files_in_folder(GDRIVE_FOLDER_ID, drive_service)
    for file_path in pathlib.Path(LOCAL_FOLDER).glob("*"):
        upload_file(str(file_path), file_path.name, GDRIVE_FOLDER_ID, existing_files, drive_service)

def main():
    if not os.path.isdir(LOCAL_FOLDER):
        print(f"Folder '{LOCAL_FOLDER}' not found.")
        return

    gdrive_files = get_existing_files_in_folder(GDRIVE_FOLDER_ID, drive_service)
    local_files = {file_path.name for file_path in pathlib.Path(LOCAL_FOLDER).glob("*") if file_path.is_file()}

    for file_path in pathlib.Path(LOCAL_FOLDER).glob("*"):
        if file_path.is_file():
            upload_file(str(file_path), file_path.name, GDRIVE_FOLDER_ID, gdrive_files, drive_service)
            print(f"File {file_path.name} was uploaded.")

    files_to_delete = set(gdrive_files.keys()) - local_files
    for filename in files_to_delete:
        file_id = gdrive_files[filename]
        drive_service.files().delete(fileId=file_id).execute()
        print(f"File {filename} was deleted.")

if __name__ == '__main__':
    main()
