(require 'transient)

(transient-define-prefix magit-extensions ()
  "My personal extensions to magit"
  [["Extensions"
  ;; coming soon?
  ]])

(with-eval-after-load 'magit
  (define-key magit-status-mode-map "@" 'magit-extensions)
  (transient-insert-suffix 'magit-dispatch "!" '("@" "Extensions" magit-extensions))

  ;; optimization for large repos
  (setq magit-refresh-status-buffer nil))

(global-set-key (kbd "M-2") 'magit-status)

(provide 'packrat386/magit)
