       identification division.
       program-id. media.

       environment division.

       data division.

       working-storage section.
       01 media-database.
           03 media-count        pic 99 usage comp-5 value 0.
           03 media-items occurs 1000 times.
               05 media-id       pic 9(10).
               05 filename       pic x(255).
               05 original-name  pic x(255).
               05 file-path      pic x(500).
               05 file-size      pic 9(10).
               05 mime-type      pic x(100).
               05 upload-date    pic x(20).
               05 uploaded-by    pic x(50).
               05 alt-text       pic x(255).
               05 description    pic x(500).
               05 status         pic x(10).

       01 current-media-index   pic 99 usage comp-5.
       01 temp-file-info.
           03 temp-filename     pic x(255).
           03 temp-size         pic 9(10).
           03 temp-mime         pic x(100).

       01 supported-mime-types.
           03 mime-count        pic 99 usage comp-5 value 8.
           03 mime-types occurs 20 times pic x(100).
           03 mime-extensions occurs 20 times pic x(10).

       linkage section.
       01 media-request.
           03 action           pic x(20).
           03 media-id         pic 9(10).
           03 filename         pic x(255).
           03 original-name    pic x(255).
           03 file-size        pic 9(10).
           03 mime-type        pic x(100).
           03 uploaded-by      pic x(50).
           03 alt-text         pic x(255).
           03 description      pic x(500).

       01 media-response.
           03 success          pic x(1).
           03 message          pic x(200).
           03 media-data.
               05 media-id     pic 9(10).
               05 filename     pic x(255).
               05 file-path    pic x(500).
               05 mime-type    pic x(100).
               05 file-size    pic 9(10).

       procedure division using media-request media-response.

       *> Initialize supported MIME types
       perform initialize-mime-types.

       *> Handle media action
       evaluate action
           when "upload"
               perform handle-upload
           when "get"
               perform handle-get
           when "list"
               perform handle-list
           when "delete"
               perform handle-delete
           when "update"
               perform handle-update
           when other
               move "N" to success
               move "Invalid action" to message
       end-evaluate.

       goback.

       initialize-mime-types section.
           move 1 to current-media-index.
           move "image/jpeg" to mime-types(current-media-index).
           move ".jpg" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "image/png" to mime-types(current-media-index).
           move ".png" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "image/gif" to mime-types(current-media-index).
           move ".gif" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "image/webp" to mime-types(current-media-index).
           move ".webp" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "application/pdf" to mime-types(current-media-index).
           move ".pdf" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "text/plain" to mime-types(current-media-index).
           move ".txt" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "application/msword" to mime-types(current-media-index).
           move ".doc" to mime-extensions(current-media-index).

           add 1 to current-media-index.
           move "application/vnd.openxmlformats-officedocument.wordprocessingml.document" to mime-types(current-media-index).
           move ".docx" to mime-extensions(current-media-index).

       handle-upload section.
           move "N" to success.
           
           *> Validate MIME type
           perform validate-mime-type.
           
           if success = "Y"
               *> Generate unique filename
               perform generate-filename.
               
               *> Add to database
               add 1 to media-count.
               move media-count to current-media-index.
               move media-count to media-id(current-media-index).
               move filename of media-request to filename(current-media-index).
               move original-name of media-request to original-name(current-media-index).
               move file-size of media-request to file-size(current-media-index).
               move mime-type of media-request to mime-type(current-media-index).
               move uploaded-by of media-request to uploaded-by(current-media-index).
               move alt-text of media-request to alt-text(current-media-index).
               move description of media-request to description(current-media-index).
               move "active" to status(current-media-index).
               move "2024-01-01 00:00:00" to upload-date(current-media-index).
               
               *> Set file path
               string "uploads/" delimited by size
                      filename(current-media-index) delimited by space
                      into file-path(current-media-index).
               
               move "Y" to success.
               move "File uploaded successfully" to message.
               move media-id(current-media-index) to media-id of media-data.
               move filename(current-media-index) to filename of media-data.
               move file-path(current-media-index) to file-path of media-data.
               move mime-type(current-media-index) to mime-type of media-data.
               move file-size(current-media-index) to file-size of media-data.
           end-if.

       handle-get section.
           move "N" to success.
           perform varying current-media-index from 1 by 1
               until current-media-index > media-count
               if media-id(current-media-index) = media-id of media-request
                   if status(current-media-index) = "active"
                       move "Y" to success.
                       move "Media found" to message.
                       move media-id(current-media-index) to media-id of media-data.
                       move filename(current-media-index) to filename of media-data.
                       move file-path(current-media-index) to file-path of media-data.
                       move mime-type(current-media-index) to mime-type of media-data.
                       move file-size(current-media-index) to file-size of media-data.
                       exit perform
                   end-if
               end-if
           end-perform.

           if success = "N"
               move "Media not found" to message
           end-if.

       handle-list section.
           move "Y" to success.
           move "Media list retrieved" to message.
           *> In a real implementation, this would return a list of media items

       handle-delete section.
           move "N" to success.
           perform varying current-media-index from 1 by 1
               until current-media-index > media-count
               if media-id(current-media-index) = media-id of media-request
                   move "deleted" to status(current-media-index).
                   move "Y" to success.
                   move "Media deleted successfully" to message.
                   exit perform
               end-if
           end-perform.

           if success = "N"
               move "Media not found" to message
           end-if.

       handle-update section.
           move "N" to success.
           perform varying current-media-index from 1 by 1
               until current-media-index > media-count
               if media-id(current-media-index) = media-id of media-request
                   if status(current-media-index) = "active"
                       move alt-text of media-request to alt-text(current-media-index).
                       move description of media-request to description(current-media-index).
                       move "Y" to success.
                       move "Media updated successfully" to message.
                       exit perform
                   end-if
               end-if
           end-perform.

           if success = "N"
               move "Media not found" to message
           end-if.

       validate-mime-type section.
           move "N" to success.
           perform varying current-media-index from 1 by 1
               until current-media-index > mime-count
               if mime-types(current-media-index) = mime-type of media-request
                   move "Y" to success.
                   exit perform
               end-if
           end-perform.

           if success = "N"
               move "Unsupported file type" to message
           end-if.

       generate-filename section.
           *> Generate a unique filename based on timestamp and original name
           *> This is a simplified version - in production, use proper UUID generation
           move filename of media-request to temp-filename.

       end program media.
