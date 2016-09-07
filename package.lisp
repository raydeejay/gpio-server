;;;; package.lisp

(defpackage #:gpio-server
  (:use #:cl #:gpio #:split-sequence)
  (:export #:main))
