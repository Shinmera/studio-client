#|
 This file is a part of Studio-Client
 (c) 2018 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:studio-client
  (:nicknames #:org.shirakumo.studio.client)
  (:use #:cl)
  (:shadow #:delete)
  ;; client.lisp
  (:export
   #:client
   #:api-base
   #:gallery
   #:id
   #:author
   #:cover
   #:description
   #:make-gallery
   #:gallery
   #:galleries
   #:delete
   #:save
   #:upload
   #:id
   #:url
   #:title
   #:author
   #:tags
   #:created
   #:visibility
   #:description
   #:files
   #:upload
   #:make-upload
   #:uploads
   #:delete
   #:save
   #:file-url
   #:file-content))
