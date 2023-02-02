;;------------------------------------------------------------------------------
;; Setup
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/lisp/external")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(defun ensure-package (package-name)
  (unless (package-installed-p package-name)
    (package-install package-name)))

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;;------------------------------------------------------------------------------
;; General Hotkeys and stuff
;;------------------------------------------------------------------------------
(global-set-key (kbd "M-1") 'compile)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

(setq-default indent-tabs-mode nil)
(setq column-number-mode t)

(ensure-package 'cyberpunk-theme)
(load-theme 'cyberpunk t)

;; don't need random backup garbage
(setq backup-directory-alist '(("." . "~/.emacs.d/.crap/backups")))

;; support ansi colors in compilation
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(ensure-package 'magit)
(global-set-key (kbd "M-2") 'magit-status)
(setq magit-refresh-status-buffer nil) ;; optimization for gigantic repos?

;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(ensure-package 'ruby-mode)
(ensure-package 'rspec-mode)
(ensure-package 'yaml-mode)

(defun rspec-spec-file-for (a-file-name)
  "Find spec for the specified file."
  (if (rspec-spec-file-p a-file-name)
      a-file-name
      (rspec-spec-file-for-target a-file-name)))

(defun rspec-spec-file-for-target (a-file-name)
  (cl-loop for pfx in (rspec-primary-source-dirs-prefix)
           for target = (expand-file-name
                         (string-remove-prefix pfx (rspec-hypothetical-spec-file-for-target a-file-name))
                         (rspec-spec-directory a-file-name))
           if (file-exists-p target)
           return target))

(defun rspec-hypothetical-spec-file-for-target (a-file-name)
  (rspec-specize-file-name
   (file-relative-name
    a-file-name
    (rspec-spec-directory a-file-name))))

  (defun rspec-primary-source-dirs-prefix ()
    (cons
     "../"
     (cl-loop for pfx in rspec-primary-source-dirs
           collect (concat "../" pfx "/"))))

;;------------------------------------------------------------------------------
;; Go Stuff
;;------------------------------------------------------------------------------
(ensure-package 'go-mode)
(add-hook
 'go-mode-hook
 (lambda ()
   (add-hook 'before-save-hook #'gofmt-before-save)))
                          
;;------------------------------------------------------------------------------
;; Shell Stuff
;;------------------------------------------------------------------------------
(add-hook
 'sh-mode-hook
 (lambda ()
   (setq sh-basic-offset 2
         sh-indentation 2)))

;;------------------------------------------------------------------------------
;; Markdown Stuff
;;------------------------------------------------------------------------------
(ensure-package 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;------------------------------------------------------------------------------
;; Lisp
;;------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.el\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.lisp\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("emacs\\'" . lisp-mode))

;;------------------------------------------------------------------------------
;; HCl
;;------------------------------------------------------------------------------
(ensure-package 'hcl-mode)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . hcl-mode))

;;------------------------------------------------------------------------------
;; Java (WIP, got some flexport stuff)
;;------------------------------------------------------------------------------
(ensure-package 'bazel)

(require 'packrat386/fx-java)

(add-to-list 'java-mode-hook 'fx-java-mode)
