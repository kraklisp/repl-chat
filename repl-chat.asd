;;;; repl-chat.asd

(asdf:defsystem #:repl-chat
  :description "A very small chat written for SLIME-connecting to a single machine"
  :author "Kamil <ziemniakzkosmosu@gmail.com>, karhu <karhu@protonmail.com>, phoe <phoe@openmailbox.org>"
  :depends-on (#:iterate #:swank)
  :serial t
  :components ((:file "repl-chat")))

