;;------------------------------------------------------------------------------
;; Setup
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(require 'bind-key)

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;;------------------------------------------------------------------------------
;; General Hotkeys and stuff
;;------------------------------------------------------------------------------
(require 'compile)
(bind-key "M-1" 'compile)
(bind-key "C-c C-c" 'comment-or-uncomment-region)

(setq-default indent-tabs-mode nil)
(setq column-number-mode t)

(use-package cyberpunk-theme :ensure t)
(load-theme 'cyberpunk t)

;; don't need random backup garbage
(setq backup-directory-alist '(("." . "~/.emacs.d/.crap/backups")))

;; support ansi colors in compilation
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(use-package magit
  :ensure t
  :bind ("M-2" . magit-status))
(setq magit-refresh-status-buffer nil)


;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(use-package ruby-mode
  :ensure t
  :mode "\\.rb$")
(use-package rubocop :ensure t)
(use-package rspec-mode :ensure t)
(use-package yaml-mode :ensure t)
(use-package haml-mode :ensure t)

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
(use-package go-mode
  :ensure t
  :config
  (add-hook 'before-save-hook 'gofmt-before-save))

;;------------------------------------------------------------------------------
;; Shell Stuff
;;------------------------------------------------------------------------------
(use-package sh-script
  :config
  (setq sh-basic-offset 2
        sh-indentation 2))

;;------------------------------------------------------------------------------
;; Markdown Stuff
;;------------------------------------------------------------------------------
(use-package markdown-mode
  :ensure t
  :commands (gfm-mode)
  :mode "\\.md$")

;;------------------------------------------------------------------------------
;; Lisp
;;------------------------------------------------------------------------------
(use-package lisp-mode
  :mode "\\.el$" "\\.lisp$" "\\.cl$" "emacs$")


;;------------------------------------------------------------------------------
;; HCl
;;------------------------------------------------------------------------------
(use-package hcl-mode
  :ensure t
  :mode "\\.tf$")


;;------------------------------------------------------------------------------
;; Java (WIP, got some flexport stuff)
;;------------------------------------------------------------------------------
(use-package bazel :ensure t)

(require 'packrat386/fx-java)

(use-package auto-revert-mode :hook java-mode)
(use-package java-mode
    :bind (:map java-mode-map
           ("C-c b" . fx-java-build-package-local)
           ("C-c v" . fx-java-test-package-local)
           ("C-c r" . fx-java-run-package-local)
           ("C-c c" . fx-java-check-package-local)
           ("C-c t" . fx-java-toggle-main-or-test)
           ("C-c f" . fx-java-format-project)))
