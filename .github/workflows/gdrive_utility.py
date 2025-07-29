from googleapiclient.http import MediaFileUpload
from googleapiclient.discovery import build

def get_existing_files_in_folder(folder_id, drive_service):
    existing_files = {}
    page_token = None
    while True:
        response = drive_service.files().list(
            q=f"'{folder_id}' in parents and trashed = false",
            spaces='drive',
            fields='nextPageToken, files(id, name)',
            pageToken=page_token
        ).execute()
        for file in response.get('files', []):
            existing_files[file['name']] = file['id']
        page_token = response.get('nextPageToken', None)
        if page_token is None:
            break
    return existing_files

# upload with override
def upload_file(file_path, filename, folder_id, existing_files, drive_service):
    file_metadata = {
        'name': filename,
        'parents': [folder_id]
    }
    media = MediaFileUpload(file_path, resumable=True)

    if filename in existing_files:
        file_id = existing_files[filename]
        updated_file = drive_service.files().update(
            fileId=file_id,
            media_body=media
        ).execute()
        print(f'Updated {filename}, file ID: {file_id}')
    else:
        uploaded_file = drive_service.files().create(
            body=file_metadata,
            media_body=media,
            fields='id'
        ).execute()
        print(f'Uploaded {filename}, file ID: {uploaded_file.get("id")}')
