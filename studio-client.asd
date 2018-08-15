#|
 This file is a part of Studio-Client
 (c) 2018 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(asdf:defsystem studio-client
  :version "1.0.0"
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "A client library for the Studio image hosting service"
  :homepage "https://github.com/Shinmera/studio-client"
  :serial T
  :components ((:file "package")
               (:file "client")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :north-core
               :babel
               :yason))
