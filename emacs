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

(require 'use-package)
(require 'bind-key)


;;------------------------------------------------------------------------------
;; General Hotkeys
;;------------------------------------------------------------------------------
(require 'compile)
(global-set-key (kbd "M-1") 'compile)
(setq-default indent-tabs-mode nil)

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(require 'git)
(require 'git-blame)
(global-set-key (kbd "M-2") 'git-status)

;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(use-package enh-ruby-mode
  :mode "\\.rb$"
  :interpreter "ruby"
  :config
  (bind-keys :map enh-ruby-mode-map
             ("M-3" . rubocop-check-current-file)          
             ("M-#" . rubocop-check-project))
  (setq enh-ruby-deep-arglist nil
        enh-ruby-deep-indent-paren nil
        enh-ruby-deep-indent-paren-style nil
        enh-ruby-add-encoding-comment-on-save nil))
(use-package rubocop)
(use-package rspec-mode)
(use-package yaml-mode)

;;------------------------------------------------------------------------------
;; Rails Stuff
;;------------------------------------------------------------------------------
(use-package haml-mode)

;;------------------------------------------------------------------------------
;; Go Stuff
;;------------------------------------------------------------------------------
(use-package go-mode
  :config
  (setq exec-path (cons "/usr/local/go/bin" exec-path))
  (add-to-list 'exec-path "/Users/acoyle/go/bin")
  (add-hook 'before-save-hook 'gofmt-before-save))

;;------------------------------------------------------------------------------
;; Shell Stuff
;;------------------------------------------------------------------------------
(use-package sh-mode
  :init
  (add-hook 'sh-mode-hook
              (setq-default sh-basic-offset 2
                            sh-indentation 2)))
