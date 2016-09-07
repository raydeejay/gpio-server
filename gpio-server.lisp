;;;; gpio-server.lisp

(in-package #:gpio-server)

;;; "gpio-server" goes here. Hacks and glory await!

(defparameter *exported-pins* NIL
  "List of exported pins so they can be unexported at exit.")

(defparameter *auto-unexport* T
  "If set to NIL, prevents the server from unexporting the exported pins on exit.")

(defun interpret (cmdline)
  (let* ((tokens (split-sequence #\Space
                                 (string-trim " " cmdline)
                                 :remove-empty-subseqs T)))
    (case (intern (string-upcase (first tokens)) :gpio-server)
      ((e ex export)
       (push (second tokens) *exported-pins*)
       (gpio-export (second tokens))
       :exported)
      ((u unex unexport)
       (setf *exported-pins*
             (remove (second tokens)
                     *exported-pins*
                     :test #'string-equal))
       (gpio-unexport (second tokens))
       :unexported)
      ((d dir direction)
       (gpio-direction (second tokens) (third tokens))
       :direction)
      ((w write)
       (gpio-write (second tokens) (third tokens))
       :write)
      ((r read)
       (gpio-read (second tokens)))
      ((z delay)
       (sleep (/ (parse-integer (second tokens)) 1000))
       :delayed)
      ((q quit) :quit)
      (otherwise :error))))

(defun main (&optional args)
  (declare (ignorable args))
  (setf *exported-pins* nil)
  (format t "WELCOME!!~%")
  (unwind-protect
       (loop :for line := (read-line)
          :for result := (interpret line)
          :unless (eql result :quit)
          :do (format t "~A~%" result)
          :while (not (eql result :quit)))
    (when *auto-unexport*
      (mapc #'gpio-unexport *exported-pins*))))
