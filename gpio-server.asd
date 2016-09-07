;;;; gpio-server.asd

(asdf:defsystem #:gpio-server
  :description "Describe gpio-server here"
  :author "Sergi Reyner <sergi.reyner@gmail.com>"
  :license "MIT"
  :depends-on (#:rpi-gpio #:split-sequence)
  :serial t
  :components ((:file "package")
               (:file "gpio-server")))
