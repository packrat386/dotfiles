(defun fx-monorepo-root-compile (command &rest args)
  (let ((default-directory (fx-monorepo-root)))
    (compile
     (mapconcat
      #'shell-quote-argument
      (cons command args)
      " "))))

(defun fx-monorepo-root ()
  (expand-file-name
   (or
    (getenv "FLEXPORT_ROOT")
    "~/flexport")))

(provide 'packrat386/fx-util)
