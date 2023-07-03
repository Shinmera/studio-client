(asdf:defsystem studio-client
  :version "1.1.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "A client library for the Studio image hosting service"
  :homepage "https://github.com/Shinmera/studio-client"
  :serial T
  :components ((:file "package")
               (:file "client")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :north-core
               :babel
               :com.inuoe.jzon))
