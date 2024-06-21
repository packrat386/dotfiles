(defun rmake-make (target)
  "Search upwards recursively for a Makefile and run `make TARGET'
 in that directory"
  (interactive
   (list (read-string "target: ")))
  (rmake--root-compile target))

(defun rmake--root-compile (target)
  (let ((default-directory (rmake--project-root)))
    (compile
     (format "make %s" target))))

(defun rmake--parent-directory (a-directory)
  (file-name-directory (directory-file-name a-directory)))

(defun rmake--root-directory-p (a-directory)
  (equal a-directory (rspec-parent-directory a-directory)))

(defun rmake--project-root-directory-p (directory)
  (file-regular-p (expand-file-name "Makefile" directory)))

(defun rmake--project-root (&optional directory)
  (let ((directory (file-name-as-directory (expand-file-name (or directory default-directory)))))
    (cond
     ((rmake--root-directory-p directory) (error "no Makefile found up to fs root"))
     ((rmake--project-root-directory-p directory) directory)
     (t (rmake--project-root (rmake--parent-directory directory))))))

(provide 'packrat386/rmake)
