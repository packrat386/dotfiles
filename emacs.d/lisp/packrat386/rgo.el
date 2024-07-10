(define-minor-mode rgo-mode
    "A minor mode providing some utilities for go projects"
  :lighter " [r]"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c t") 'rgo-toggle-main-or-test)
            (define-key map (kbd "C-c v") 'rgo-test-current-package)
            map))

(defun rgo-toggle-main-or-test ()
  "Toggles between 'main' and test files within the same package"
  (interactive)
  (find-file
   (rgo--main-or-test buffer-file-name))) 

(defun rgo--main-or-test (target-file)
  (if (rgo--is-test-p target-file)
      (rgo--main-path-for target-file)
      (rgo--test-path-for target-file)))

(defun rgo--is-test-p (target-file)
  (string-match-p "_test\\.go$" target-file))

(defun rgo--main-path-for (target-file)
  (replace-regexp-in-string
   "_test\\.go$"
   ".go"
   target-file))

(defun rgo--test-path-for (target-file)
  (replace-regexp-in-string
   "\\.go$"
   "_test.go"
   target-file))

(defun rgo-test-current-package ()
  "Run tests in the current package"
  (interactive)
  (compile "go test"))

(defun rgo-add-testify-compilation-re ()
  "Adds a regexp to `compilation-error-regexp-alist' to match
error message displayed by tesitfy's assert or require packages"
  (when (and (boundp 'compilation-error-regexp-alist)
              (boundp 'compilation-error-regexp-alist-alist))
     (add-to-list 'compilation-error-regexp-alist 'testify-assertion)
     (add-to-list
      'compilation-error-regexp-alist-alist
      (list
       'testify-assertion
       (rx
        bol
        (* space)
        "Error Trace:"
        (* space)
        (group-n 1 (* (not ":")))
        ":"
        (group-n 2 (* digit))
        eol)
       1
       2)
      t)))

(provide 'packrat386/rgo)
