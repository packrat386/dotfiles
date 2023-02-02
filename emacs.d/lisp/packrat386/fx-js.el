(require 'js)

(require 'packrat386/fx-util)

(define-minor-mode fx-js-mode
    "A minor mode providing some utilities for flexport's front-end"
  :lighter " fx"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c c") 'fx-js-check-flow)            
            (define-key map (kbd "C-c f") 'fx-js-lint-current-buffer)
            (define-key map (kbd "C-c F") 'fx-js-lint-diverged)
            map))

;; so that the results of fx-js-lint-* will be visible
(add-hook 'fx-js-mode-hook 'auto-revert-mode)

(defun fx-js-lint-current-buffer ()
  "Runs flexport's js linter on the current buffer"
  (interactive)
  (fx-monorepo-root-compile (fx-js-lint-script) "--fix" buffer-file-name))

(defun fx-js-lint-diverged ()
  "Runs flexport's js linter on all diverged files"
  (interactive)
  (fx-monorepo-root-compile (fx-js-lint-script) "--fix" "diverged_js"))

(defun fx-js-check-flow ()
  "Gets type errors from `flow status`"
  (interactive)
  (fx-monorepo-root-compile "yarn" "run" "flow" "status" "--from" "emacs"))

(defun fx-js-lint-script ()
  (expand-file-name "script/flexport/lint.rb" (fx-monorepo-root)))

(provide 'packrat386/fx-js)
