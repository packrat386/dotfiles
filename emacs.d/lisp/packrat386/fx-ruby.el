(require 'ruby-mode)
(require 'rspec-mode)

(require 'packrat386/fx-util)

(define-minor-mode fx-ruby-mode
    "A minor mode providing some utilities for flexports ruby apps"
  :lighter " fx"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c v") 'rspec-verify)
            (define-key map (kbd "C-c t") 'rspec-toggle-spec-and-target)
            (define-key map (kbd "C-c f") 'fx-ruby-lint-current-buffer)
            (define-key map (kbd "C-c F") 'fx-ruby-lint-diverged)
            map))

;; so that the results of fx-ruby-lint-* will be visible
(add-hook 'fx-ruby-mode-hook 'auto-revert-mode)

(defun fx-ruby-lint-current-buffer ()
  "Runs flexport's ruby linter on the current buffer"
  (interactive)
  (fx-monorepo-root-compile (fx-ruby-lint-script) "--autocorrect" buffer-file-name))

(defun fx-ruby-lint-diverged ()
  "Runs flexport's ruby linter on all diverged files"
  (interactive)
  (fx-monorepo-root-compile (fx-ruby-lint-script) "--autocorrect" "diverged"))

(defun fx-ruby-lint-script ()
  (expand-file-name "script/flexport/lint.rb" (fx-monorepo-root)))

;; monkeypatch 'rspec-spec-file-for so that we can find specs in the monolith's engines, e.g.:
;; engines/execution_plan_extract/app/services/execution_plan_extract/upsert_shipment_execution_plan.rb
;; maps to
;; engines/execution_plan_extract/spec/services/execution_plan_extract/upsert_shipment_execution_plan.rb
;; not
;; engines/execution_plan_extract/spec/app/services/execution_plan_extract/upsert_shipment_execution_plan.rb
;; (which does not exist)

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
;; end monkeypatch


(provide 'packrat386/fx-ruby)
