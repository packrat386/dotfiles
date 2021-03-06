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

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(use-package magit
  :ensure t
  :bind ("M-2" . magit-status))

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
