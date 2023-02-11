(defun dumb-tab--tab-to-tab-stop ()
  "Insert spaces or tabs to next defined tab-stop column."
  (interactive)
  (back-to-indentation)
  (let ((nexttab (indent-next-tab-stop (current-column))))
    (delete-horizontal-space t)
    (indent-to nexttab)))

(defun dumb-tab--backtab-to-tab-stop ()
  "Remove spaces or tabs to the previous defined tab-stop column."
  (interactive)
  (back-to-indentation)
  (let ((prevtab (indent-next-tab-stop (current-column) t)))
    (delete-horizontal-space t)
    (indent-to prevtab)))

(defun dumb-tab--newline ()
  "Insert a new line with indentation relative to the previous line"
  (interactive)
  (let ((indent-line-function 'indent-relative))
    (newline-and-indent)))

(define-minor-mode dumb-tab-mode
    "A minor mode for inserting tabs the dumb way. TAB will indent
to the next tab stop and shift + TAB (backtab?) will indent back
to the previous tab stop. RET will will `indent-relative'.

You probably need to set `tab-width' for this to work right (unless
you want the default 8 space tabs)."
  :lighter " dTAB"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<backtab>") 'dumb-tab--backtab-to-tab-stop)
            (define-key map (kbd "RET") 'dumb-tab--newline)
            map)
  (setq-local indent-line-function 'dumb-tab--tab-to-tab-stop)
  (setq-local electric-indent-inhibit t))

(provide 'packrat386/dumb-tab)
