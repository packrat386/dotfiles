(defun dumb-tab-tab ()
  "Wraps `indent-for-tab-command' but overrides `indent-line-function'
to simply insert spaces or tabs to the next defined tab-stop column."
  (interactive)
  (let ((indent-line-function 'dumb-tab--tab-to-tab-stop))
    (indent-for-tab-command)))

(defun dumb-tab--tab-to-tab-stop ()
  "Insert spaces or tabs to next defined tab-stop column."
  (interactive)
  (back-to-indentation)
  (let ((nexttab (indent-next-tab-stop (current-column))))
    (delete-horizontal-space t)
    (indent-to nexttab)))

(defun dumb-tab-backtab ()
  "Wraps `indent-for-tab-command' but overrides `indent-line-function'
to simply remove spaces or tabs to the previous defined tab-stop column."
  (interactive)
  (let ((indent-line-function 'dumb-tab--backtab-to-tab-stop))
    (indent-for-tab-command)))

(defun dumb-tab--backtab-to-tab-stop ()
  "Remove spaces or tabs to the previous defined tab-stop column."
  (interactive)
  (back-to-indentation)
  (let ((prevtab (indent-next-tab-stop (current-column) t)))
    (delete-horizontal-space t)
    (indent-to prevtab)))

(defun dumb-tab-newline ()
  "Insert a new line with indentation relative to the previous line"
  (interactive)
  (let ((indent-line-function 'indent-relative))
    (newline-and-indent)))

(defun dumb-tab-set-width (local-width)
  "Set tab-width locally"
  (interactive
   (list (read-number "width: " 2)))
  (setq-local tab-width local-width))

(defun dumb-tab--toggle-electric-inhibit ()
  "When enabled, save the old value of `electric-indent-inhibit' and
then set it to true. When disabled restore the old value. Don't call
this directly."
  (if
   dumb-tab-mode
   (setq-local
    dumb-tab--orig-electric-indent-inhibit electric-indent-inhibit
    electric-indent-inhibit t)
   (setq-local
    electric-indent-inhibit dumb-tab--orig-electric-indent-inhibit)))

(make-variable-buffer-local
 (defvar dumb-tab--orig-electric-indent-inhibit nil
   "Holder for what `electric-indent-inhibit' was before loading
this mode"))

(define-minor-mode dumb-tab-mode
    "A minor mode for inserting tabs the dumb way. TAB will indent
to the next tab stop and shift + TAB (backtab?) will indent back
to the previous tab stop. RET will will `indent-relative'.

You probably need to set `tab-width' for this to work right (unless
you want the default 8 space tabs)."
  :lighter " dTAB"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "TAB") 'dumb-tab-tab)
            (define-key map (kbd "<backtab>") 'dumb-tab-backtab)
            (define-key map (kbd "RET") 'dumb-tab-newline)
            (define-key map (kbd "C-x t w") 'dumb-tab-set-width)
            map)
  (dumb-tab--toggle-electric-inhibit))

(provide 'packrat386/dumb-tab)
