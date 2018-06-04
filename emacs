;;------------------------------------------------------------------------------
;; Setup
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'package) ;; You might already have this line
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

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

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(use-package magit
  :ensure t
  :bind ("M-2" . magit-status))

;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(use-package enh-ruby-mode
  :ensure t
  :mode "\\.rb$"
  :interpreter "ruby"
  :config (setq enh-ruby-deep-arglist nil
                enh-ruby-deep-indent-paren nil
                enh-ruby-deep-indent-paren-style nil
                enh-ruby-add-encoding-comment-on-save nil
                enh-ruby-program "/Users/acoyle/.rubies/ruby-2.2.2/bin/ruby") ; ruby 2.2.2 is pretty stable
  :bind (:map enh-ruby-mode-map
              ("M-3" . rubocop-check-current-file)          
              ("M-#" . rubocop-check-project)))
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
  ;; TODO: infer GOROOT
  (add-to-list 'exec-path "/Users/acoyle/go/bin")
  (add-hook 'before-save-hook 'gofmt-before-save))
(use-package go-guru
  :ensure t)

;;------------------------------------------------------------------------------
;; Shell Stuff
;;------------------------------------------------------------------------------
(use-package sh-mode
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
;; Clojure
;;------------------------------------------------------------------------------
(use-package clojure-mode :ensure t)
(use-package cider :ensure t)
