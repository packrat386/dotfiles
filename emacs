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
(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)

(setq-default indent-tabs-mode nil)
(setq column-number-mode t)

(ensure-package 'cyberpunk-theme)
(load-theme 'cyberpunk t)

;; don't need random backup garbage
(setq backup-directory-alist '(("." . "~/.emacs.d/.crap/backups")))

;; support ansi colors in compilation
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;;------------------------------------------------------------------------------
;; (R)oot Make
;;------------------------------------------------------------------------------
(require 'packrat386/rmake)
(global-set-key (kbd "C-c m") 'rmake-make)

;;------------------------------------------------------------------------------
;; Dumb Tab Mode
;;------------------------------------------------------------------------------
(require 'packrat386/dumb-tab)
(global-set-key (kbd "C-M-y") 'dumb-tab-mode)

;;------------------------------------------------------------------------------
;; Git
;;------------------------------------------------------------------------------
(ensure-package 'magit)
(require 'packrat386/magit)
(require 'packrat386/gh-helpers)

;;------------------------------------------------------------------------------
;; Ruby Stuff
;;------------------------------------------------------------------------------
(ensure-package 'ruby-mode)
(ensure-package 'rspec-mode)
(ensure-package 'yaml-mode)

(require 'packrat386/rspec-monkeypatch)

;;------------------------------------------------------------------------------
;; Go Stuff
;;------------------------------------------------------------------------------
(ensure-package 'go-mode)
(add-hook
 'go-mode-hook
 (lambda ()
   (add-hook 'before-save-hook #'gofmt-before-save)))

(require 'packrat386/rgo)
(add-hook 'go-mode-hook 'rgo-mode)
(add-hook 'go-mode-hook 'rgo-add-testify-compilation-re)


;;------------------------------------------------------------------------------
;; Shell Stuff
;;------------------------------------------------------------------------------
(add-hook
 'sh-mode-hook
 (lambda ()
   (setq sh-basic-offset 2
         sh-indentation 2)))

(add-to-list 'auto-mode-alist '("bashrc\\'" . sh-mode))

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
;; JavaScript Stuff
;;------------------------------------------------------------------------------
(with-eval-after-load 'js
  (add-to-list 'js-mode-hook 'dumb-tab-mode)
  (add-hook
   'js-mode-hook
   (lambda ()
     (setq-local tab-width 2))))

;;------------------------------------------------------------------------------
;; Employer Specific Config
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.employer/elisp")
(require 'employer-setup nil 'noerror) ;; noerror cause this might not be there
