#|
 This file is a part of Studio-Client
 (c) 2018 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.studio.client)

(defclass client (north:client)
  ((api-base :reader api-base))
  (:default-initargs
   :api-base "https://studio.tymoon.eu/api/"
   :request-token-uri NIL
   :authorize-uri NIL
   :access-token-uri NIL))

(defmethod initialize-instance :after ((client client) &key api-base)
  (setf api-base (string-right-trim "/" api-base))
  (setf (slot-value client 'api-base) api-base)
  (unless (north:request-token-uri client)
    (setf (north:request-token-uri client) (format NIL "~a/oauth/request-token" api-base)))
  (unless (north:authorize-uri client)
    (setf (north:authorize-uri client) (format NIL "~a/oauth/authorize" api-base)))
  (unless (north:access-token-uri client)
    (setf (north:access-token-uri client) (format NIL "~a/oauth/access-token" api-base)))
  (unless (north:verify-uri client)
    (setf (north:verify-uri client) (format NIL "~a/oauth/verify" api-base))))

(Defun plist->params (plist)
  (loop for (key val) on plist by #'cddr
        when val
        collect (cons (string-downcase key)
                      (princ-to-string val))))

(defgeneric post (client endpoint &rest parameters))

(defun decode-radiance-payload (data)
  (let ((json (yason:parse (etypecase data
                             (string data)
                             (vector (babel:octets-to-string data))
                             (stream data))
                           :json-booleans-as-symbols T
                           :json-nulls-as-keyword NIL)))
    (when (/= 200 (gethash "status" json))
      (error "Studio request failed: ~s" (gethash "message" json)))
    (gethash "data" json)))

(defmethod post ((client client) endpoint &rest parameters)
  (decode-radiance-payload
   (north:make-signed-request client (format NIL "~a/~a" (api-base client) endpoint)
                              :post :params (plist->params (list* :format "json" parameters)))))

(defmethod post-file ((client client) endpoint data &rest parameters)
  (decode-radiance-payload
   (north:make-signed-data-request client (format NIL "~a/~a" (api-base client) endpoint)
                                   data :params (plist->params (list* :format "json" parameters)))))

(defclass gallery ()
  ((id :initarg :id :reader id)
   (url :initarg :url :reader url)
   (author :initarg :author :reader author)
   (cover :initarg :cover :accessor cover)
   (description :initarg :description :accessor description)))

(defmethod print-object ((gallery gallery) stream)
  (print-unreadable-object (gallery stream :type T)
    (format stream "~a #~a" (author gallery) (id gallery))))

(defun parse-gallery (data)
  (make-instance 'gallery :id (gethash "id" (gethash "author" data))
                          :url (gethash "url" data)
                          :author (gethash "username" (gethash "author" data))
                          :description (gethash "description" data)
                          :cover (gethash "cover" data)))

(defmethod make-gallery ((client client) &key description)
  (parse-gallery (post client "studio/gallery/create"
                       :description description)))

(defmethod gallery ((client client) author)
  (parse-gallery (post client "studio/gallery"
                       :author author)))

(defmethod galleries ((client client) &key (start 0) end)
  (mapcar #'parse-gallery (post client "studio/gallery/list"
                                :skip start
                                :amount (when end (- end start)))))

(defmethod delete ((client client) (gallery gallery))
  (post client "studio/gallery/delete"
        :author (author gallery)))

(defmethod save ((client client) (gallery gallery))
  (post client "studio/gallery/edit"
        :author (author gallery)
        :description (description gallery)
        :cover (etypecase (cover gallery)
                 (integer (princ-to-string (cover gallery)))
                 (string (cover gallery))
                 (upload (id (cover gallery))))))

(defclass upload ()
  ((id :initarg :id :reader id)
   (url :initarg :url :reader url)
   (title :initarg :title :accessor title)
   (author :initarg :author :reader author)
   (tags :initarg :tags :accessor tags)
   (created :initarg :created :accessor created)
   (visibility :initarg :visibility :accessor visibility)
   (arrangement :initarg :arrangement :accessor arrangement)
   (description :initarg :description :accessor description)
   (files :initarg :files :accessor files)))

(defmethod print-object ((upload upload) stream)
  (print-unreadable-object (upload stream :type T)
    (format stream "~s #~a" (title upload) (id upload))))

(defun parse-upload (data)
  (make-instance 'upload :id (gethash "id" data)
                         :url (gethash "url" data)
                         :title (gethash "title" data)
                         :author (gethash "author" data)
                         :tags (gethash "tags" data)
                         :created (gethash "time" data)
                         :visibility (cond ((string= "public" (gethash "visibility" data)) :public)
                                           ((string= "hidden" (gethash "visibility" data)) :hidden)
                                           ((string= "private" (gethash "visibility" data)) :private))
                         :arrangement (cond ((string= "top-to-bottom" (gethash "arrangement" data)) :top-to-bottom)
                                            ((string= "left-to-right" (gethash "arrangement" data)) :left-to-right)
                                            ((string= "right-to-left" (gethash "arrangement" data)) :right-to-left)
                                            ((string= "tiled" (gethash "arrangement" data)) :tiled))
                         :description (gethash "description" data)
                         :files (gethash "files" data)))

(defmethod upload ((client client) id)
  (parse-upload (post client "studio/upload" :id id)))

(defmethod make-upload ((client client) title files &key description tags (visibility :public) (arrangement :top-to-bottom))
  (parse-upload (post-file client "studio/upload/create"
                           (loop for file in files
                                 collect `("file[]" . ,file))
                           :title title
                           :description description
                           :tags (format NIL "~{~a~^,~}" tags)
                           :visibility (ecase visibility
                                         (:public "public")
                                         (:hidden "hidden")
                                         (:private "private"))
                           :arrangement (ecase arrangement
                                          (:top-to-bottom "top-to-bottom")
                                          (:left-to-right "left-to-right")
                                          (:right-to-left "right-to-left")
                                          (:tiled "tiled")))))

(defmethod uploads ((client client) (author string) &key tag date (start 0) end)
  (mapcar #'parse-upload (post client "studio/upload/list"
                               :tag tag
                               :date date
                               :skip start
                               :amount (when end (- end start)))))

(defmethod uploads ((client client) (gallery gallery) &rest args)
  (apply #'uploads client (author gallery) args))

(defmethod delete ((client client) (upload upload))
  (post client "studio/upload/delete"
        :upload (id upload)))

(defmethod save ((client client) (upload upload))
  (post client "studio/upload/edit"
        :upload (id upload)
        :title (title upload)
        :description (description upload)
        :tags (format NIL "~{~a~^,~}" (tags upload))
        :visibility (ecase (visibility upload)
                      (:public "public")
                      (:hidden "hidden")
                      (:private "private"))
        :arrangement (ecase arrangement
                       (:top-to-bottom "top-to-bottom")
                       (:left-to-right "left-to-right")
                       (:right-to-left "right-to-left")
                       (:tiled "tiled"))))

(defmethod file-url ((client client) id &key thumb)
  (format NIL "~a/studio/file?id=~d~@[&thumb=true~]" (api-base client) id thumb))

(defmethod file-content ((client client) id &key thumb)
  (north:make-signed-request client (format NIL "~a/studio/file" (api-base client))
                             :post :params `(("id" . ,(princ-to-string id))
                                             ("thumb" . ,(if thumb "true" "")))))
