;;------------------------------------------------------------------------------
;; Load Path
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")

;;------------------------------------------------------------------------------
;; General Hotkeys
;;------------------------------------------------------------------------------
(require 'compile)
(global-set-key (kbd "M-1") 'compile)

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(require 'git)
(require 'git-blame)
(global-set-key (kbd "M-2") 'git-status)

;;------------------------------------------------------------------------------
;; Testing
;;------------------------------------------------------------------------------
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(require 'rspec-mode)
(defun rat-ruby-compilation() 
  (set (make-local-variable 'compile-command)
       (format "ruby %s"
	       (file-name-nondirectory buffer-file-name))) 
  (set (make-local-variable 'rubocop-command)
       (format "rubocop %s"
	       (file-name-nondirectory buffer-file-name)))
  (local-set-key (kbd "M-3") 'rat-rubocop-check)
  (local-set-key (kbd "M-#") 'rat-rubocop-all)
  (local-set-key (kbd "M-4") 'rat-rspec-class))

(defun rat-rubocop-check()
  (interactive)
  (compile rubocop-command))

(defun rat-rubocop-all()
  (interactive)
  (compile "rubocop ."))

(defun camel-to-snake (s)
  (save-match-data
    (let ((case-fold-search nil))
      (camel-to-snake-recursively s))))

(defun camel-to-snake-recursively (s)
  (let ((ss (downcase-first s)))
    (if (string-match "[A-Z]" ss)
	(concat (substring ss 0 (match-beginning 0)) "_" (camel-to-snake-recursively (substring ss (match-beginning 0) (length ss))))
      ss)))

(defun rat-rspec-class(class)
  (interactive "Mclass to test (leave empty for current file): ")
  (if (equal class "")
      (compile (format "rspec %s_spec.rb" (file-name-base buffer-file-name)))
      (compile (format "rspec %s_spec.rb" (camel-to-snake class)))))

(add-hook 'ruby-mode-hook 'rat-ruby-compilation)

;;------------------------------------------------------------------------------
;; Rails Stuff
;;------------------------------------------------------------------------------
(require 'haml-mode)

;;------------------------------------------------------------------------------
;; Go Stuff
;;------------------------------------------------------------------------------
(require 'go-mode)
(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-to-list 'exec-path "/Users/acoyle/go/bin")
(add-hook 'before-save-hook 'gofmt-before-save)
