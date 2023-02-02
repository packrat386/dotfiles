(require 'rspec-mode)

;; monkeypatch 'rspec-spec-file-for so that we can find specs in arbitrary structures
;; for example:
;; engines/my_engine/app/services/foo/update.rb
;; maps to
;; engines/my_engine/spec/services/foo/update_spec.rb
;;
;; this also solves the problem that many rails apps will have
;; lib/foo.rb
;; with specs living under
;; spec/lib/foo_spec.rb

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

(provide 'packrat386/rspec-monkeypatch)
