;;;; ;; repl-chat - a very small chat written for SLIME-connecting to a single machine
;;;;
;;;; AUTHORS: (in alphabetical order)
;;;; Kamil <ziemniakzkosmosu@gmail.com> https://github.com/KZiemian
;;;; karhu <karhu@protonmail.com>       https://github.com/lweon
;;;; phoe  <phoe@openmailbox.org>       https://github.com/phoe-krk
;;;;
;;;; (kraklisp) 2016

(defun seta (alist key value)
  (cond ((null alist)
	 (cons (cons key value) nil))
	((eq (caar alist) key)
	 (cons (cons key value) (cdr alist)))
	(t
	 (cons (first alist)
	       (seta (cdr alist) key value)))))

(defvar *chat-data* nil)
(defun chat-login (nickname)
  (let ((stream *terminal-io*))
    (setf *chat-data* (seta *chat-data* nickname stream)) 
    t))
(defun chat-logout ()
  (let ((stream *terminal-io*))
    (setf *chat-data*
	  (remove (rassoc stream *chat-data*)
		  *chat-data*))
    t))
(defun chat-whois ()
  (iterate (for cell in *chat-data*)
    (format t "~A " (car cell)))
  (terpri))

(defun msg-priv (nickname message)
  (let* ((my-stream *terminal-io*)
	 (my-nickname (car (rassoc my-stream *chat-data*)))
	 (stream (cdr (assoc nickname *chat-data*))))
    (format stream ";;[~A]: ~A~%" my-nickname message)))
(defun msg-pub (message)
  (let* ((stream *terminal-io*)
	 (my-nickname (car (rassoc stream *chat-data*))))
    (iterate (for cell in *chat-data*)
      (format (cdr cell) ";;<~A>: ~A~%" my-nickname message))))
(defun msg (nickname message)
  (if nickname
      (msg-priv nickname message)
      (msg-pub message)))

(defun public-chat-reader (stream char number)
  (declare (ignore char))
  (declare (ignore number))
  (msg-pub (read-line stream t nil t)))
(set-dispatch-macro-character #\# #\/ #'public-chat-reader)

(defun private-chat-reader (stream char number)
  (declare (ignore char))
  (declare (ignore number))
  (msg-priv (read stream t nil t) (read-line stream t nil t)))
(set-dispatch-macro-character #\# #\> #'private-chat-reader)
