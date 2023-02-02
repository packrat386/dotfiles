(require 'bazel)
(require 'cc-mode)
(require 'google-c-style)

(define-minor-mode fx-java-mode
    "A minor mode providing some utilities for flexport's java apps"
  :lighter " fx"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c b") 'fx-java-build-package-local)
            (define-key map (kbd "C-c v") 'fx-java-test-package-local)
            (define-key map (kbd "C-c r") 'fx-java-run-package-local)
            (define-key map (kbd "C-c c") 'fx-java-check-package-local)
            (define-key map (kbd "C-c t") 'fx-java-toggle-main-or-test)
            (define-key map (kbd "C-c f") 'fx-java-format-project)
            map))

;; this doesn't get the indentation perfect, but it's pretty close
(add-hook 'fx-java-mode-hook 'google-set-c-style)

;; so that the results of fx-java-format-project will be visible
(add-hook 'fx-java-mode-hook 'auto-revert-mode)

(defun fx-java-build-package-local (rule-name)
  "runs `bazel build //current/directory:$rule-name`.
rule-name defaults to the name of the directory."
  (interactive
   (list (read-string "rule-name: " (fx-java-local-dir-name buffer-file-name))))
  (bazel--compile
   "build"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

(defun fx-java-test-package-local (rule-name)
  "Runs `bazel test //current/directory:$rule-name`.
rule-name defaults to 'test'"
  (interactive
   (list (read-string "rule-name: " "test")))
  (bazel--compile
   "test"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

(defun fx-java-run-package-local (rule-name)
  "Runs `bazel run //current/directory:$rule-name`."
  (interactive (list (read-string "rule-name: ")))
  (bazel--compile
   "run"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

(defun fx-java-check-package-local ()
  "Runs `bazel run //current/directory:check`.
This is essentially a special case of 'run'"
  (interactive)
  (fx-java-run-package-local "check"))

(defun fx-java-format-project ()
  "Runs `bazel run //build-utils/format:java <project name>`.
Project name is computed based on the workspace root."
  (interactive)
  (bazel--compile
   "run"
   "--"
   "//build-utils/format:java"
   (fx-java-project-name buffer-file-name)))

(defun fx-java-toggle-main-or-test ()
  "Toggles between the 'main' and 'test' directories for a package.
If you're in src/main/x/y/Z.java go to src/test/x/y.
If you're in src/test/x/y/ZTest.java go to src/main/x/y."
  (interactive)
  (find-file (fx-java-main-or-test buffer-file-name)))

(defun fx-java-main-or-test (target-file)
  (if (fx-java-is-main-p target-file)
      (fx-java-test-dir-path-for target-file)
      (fx-java-main-dir-path-for target-file)))

(defun fx-java-is-main-p (target-file)
  (string-prefix-p
   (concat
    (fx-java-bazel-root-dir)
    (fx-java-project-name target-file)
    "/src/main/")
   target-file))

(defun fx-java-test-dir-path-for (target-file)
  (concat
   (fx-java-bazel-root-dir)
   (fx-java-project-name target-file)
   "/src/test/"
   (string-remove-prefix
    (concat (fx-java-project-name target-file) "/src/main/")
    (fx-java-local-dir-path-in-root target-file))))

(defun fx-java-main-dir-path-for (target-file)
  (concat
   (fx-java-bazel-root-dir)
   (fx-java-project-name target-file)
   "/src/main/"
   (string-remove-prefix
    (concat (fx-java-project-name target-file) "/src/test/")
    (fx-java-local-dir-path-in-root target-file))))

(defun fx-java-project-name (target-file)
  (car
   (split-string
    (fx-java-local-dir-path-in-root target-file)
    "/")))

(defun fx-java-bazel-local-rule (target-file rule-name)
  (concat
   (fx-java-bazel-local-rule-base target-file)
   ":"
   rule-name))

(defun fx-java-bazel-local-rule-base (target-file)
  (concat "//" (fx-java-local-dir-path-in-root target-file)))

(defun fx-java-local-dir-path-in-root (target-file)
  (string-remove-prefix
   (fx-java-bazel-root-dir)
   (fx-java-local-dir-path target-file)))

(defun fx-java-local-dir-name (target-file)
  (file-name-nondirectory (fx-java-local-dir-path target-file)))

(defun fx-java-local-dir-path (target-file)
  (string-remove-suffix "/" (file-name-directory target-file)))

(defun fx-java-bazel-root-dir ()
  (let*
      (
       (source-file
        (or buffer-file-name default-directory
            (user-error "Buffer doesn’t visit a file or directory")))
       (root (or (bazel--workspace-root source-file)
                 (user-error "File is not in a Bazel workspace"))))
    (file-truename root)))

(provide 'packrat386/fx-java)
