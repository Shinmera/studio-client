#|
 This file is a part of Studio-Client
 (c) 2018 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.studio.client)

(docs:define-docs
  (type client
    "The base client class for Studio connections.

To start, you should create an instance of this client with the appropriate
:API-BASE, which defaults to \"https://studio.tymoon.eu/api/\". Then use
North's functions NORTH:INITIATE-AUTHENTICATION and NORTH:COMPLETE-AUTHENTICATION
to complete the authentication cycle.

See NORTH:CLIENT
See API-BASE")

  (function api-base
    "Returns the base API URL that the client will send API requests to.

See CLIENT")

  (type gallery
    "Representation of a user's gallery in Studio.

See ID
See AUTHOR
See URL
See COVER
See DESCRIPTION
See MAKE-GALLERY
See GALLERY
See GALLERIES
See DELETE
See SAVE")

  (function id
    "Returns an ID that identifies this object on Studio.

See GALLERY
See UPLOAD")

  (function author
    "Returns the name of the author of the object.

See GALLERY
See UPLOAD")

  (function url
    "Returns the public URL to the given object.

See GALLERY
See UPLOAD")

  (function cover
    "Returns the ID of the upload that was set as the gallery's cover image, if any.

See GALLERY")

  (function description
    "Returns the object's description string.

See GALLERY
See UPLOAD")

  (function make-gallery
    "Create a gallery for the authenticated user.

Note that this will fail if a gallery already exists.

This may fail if the authenticated user lacks the necessary permissions.

Returns a fresh GALLERY instance if successful.

See GALLERY
See CLIENT")

  (function gallery
    "Retrieve the gallery of the given author.

See GALLERY
See CLIENT")

  (function galleries
    "Retrieve a listing of existing galleries on the Studio instance.

Note that this may return less than the specified END if the server
caps the number of galleries it returns (by default limited to 10).

See GALLERY
See CLIENT")

  (function delete
    "Delete the given object on the Studio instance.

This may fail if the authenticated user lacks the necessary permissions.

See GALLERY
See UPLOAD
See CLIENT")

  (function save
    "Save potential changes made to the fields of the object on the Studio instance.

This may fail if the authenticated user lacks the necessary permissions.

Returns a fresh instance of the saved object as returned by the API.

See GALLERY
See UPLOAD
See CLIENT")

  (type upload
    "Representation of an upload in a gallery on a Studio instance.

See ID
See URL
See TITLE
See AUTHOR
See TAGS
See CREATED
See VISIBILITY
See DESCRIPTION
See FILES
See MAKE-UPLOAD
See UPLOADS
See UPLOAD")

  (function title
    "Accessor to the upload's title.

Note that setting this will only change the local object. In order
to persist the changes, use SAVE.

See UPLOAD
See SAVE")

  (function tags
    "Accessor to the list of tags the upload is marked with.

Note that setting this will only change the local object. In order
to persist the changes, use SAVE.

See UPLOAD
See SAVE")

  (function created
    "Returns the universal-time timestamp of when the upload was created.

See UPLOAD")

  (function visibility
    "Accessor to the visibility of the upload.

The value may be one of: :PUBLIC :HIDDEN :PRIVATE

Note that setting this will only change the local object. In order
to persist the changes, use SAVE.

See UPLOAD
See SAVE")

  (function files
    "Accessor to the list of files of the upload.

Returned by the server are merely the file IDs, which you can
turn into URLs and payloads with FILE-URL and FILE-CONTENT
respectively.

If you want to add new files, add the pathname to the file at the
appropriate position in the file list.

Note that setting this will only change the local object. In order
to persist the changes, use SAVE.

See UPLOAD
See SAVE
See FILE-URL
See FILE-CONTENT")

  (function upload
    "Retrieve the upload with the given ID.

See UPLOAD
See CLIENT")

  (function make-upload
    "Create a new upload.

FILES should be a list of pathnames to upload as the upload's files.
VISIBILITY can be one of :PUBLIC :HIDDEN :PRIVATE.

This may fail if the authenticated user lacks the necessary permissions.

Returns a fresh UPLOAD instance if successful.

See UPLOAD
See CLIENT")

  (function uploads
    "Retrieve a list of uploads for the given user or gallery.

DATE should be a date string in the format \"MM.YYYY\".

Note that this may return less than the specified END if the server
caps the number of uploads it returns (by default limited to 40).

See GALLERY
See CLIENT
See UPLOAD")

  (function file-url
    "Returns the public URL to the file.")

  (function file-content
    "Returns the file's binary payload data as returned by the server.

Returns an unsigned-byte 8 vector.

This function will error if the requested file does not exist."))
