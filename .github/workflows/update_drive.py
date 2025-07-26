import os
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from gdrive_auth import Create_Service

# Path to your service account credentials
OAUTH2_SECRET = 'credentials.json'
SCOPES = ['https://www.googleapis.com/auth/drive']
API_TYPE = 'drive'
API_VERSION = 'v3'

# Folder containing files to upload
LOCAL_FOLDER = '../../paczka'

# Authenticate and build the Drive service
# creds = service_account.Credentials.from_client_secrets_file(
#     OAUTH2_SECRET, scopes=SCOPES)
# drive_service = build('drive', 'v3', credentials=creds)
drive_service = Create_Service(
    OAUTH2_SECRET, API_TYPE, API_VERSION, SCOPES
)

def upload_file(file_path, filename):
    file_metadata = {
        'name': filename,
        'parents': ['1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv']  # Optional: specify parent folder IDs if needed
        # You can add "parents": ["<folder_id>"] here to upload to a specific Drive folder
    }
    media = MediaFileUpload(file_path, resumable=True)
    uploaded_file = drive_service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()
    print(f'Uploaded {filename}, file ID: {uploaded_file.get("id")}')

def main():
    if not os.path.isdir(LOCAL_FOLDER):
        print(f"Folder '{LOCAL_FOLDER}' not found.")
        return

    for filename in os.listdir(LOCAL_FOLDER):
        file_path = os.path.join(LOCAL_FOLDER, filename)
        if os.path.isfile(file_path):
            upload_file(file_path, filename)

if __name__ == '__main__':
    main()
