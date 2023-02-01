;; bazel build //current/directory:$rule-name (C-c b)
;; rule-name defaults to the name of the directory
(defun fx-java-build-package-local (rule-name)
  (interactive
   (list (read-string "rule-name: " (fx-java-local-dir-name buffer-file-name))))
  (bazel--compile
   "build"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

;; bazel test //current/directory:$rule-ame (C-c v)
;; rule-name defaults to 'test'
(defun fx-java-test-package-local (rule-name)
  (interactive
   (list (read-string "rule-name: " "test")))
  (bazel--compile
   "test"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

;; bazel run //current/directory:$rule-name (C-c r <rule-name>)
(defun fx-java-run-package-local (rule-name)
  (interactive (list (read-string "rule-name: ")))
  (bazel--compile
   "run"
   "--"
   (fx-java-bazel-local-rule buffer-file-name rule-name)))

;; bazel run //current/directory:check (C-c c)
;; this is essentially a special case of "run"
(defun fx-java-check-package-local ()
  (interactive)
  (fx-java-run-package-local "check"))

;; bazel run //build-utils/format:java <project name> (C-c f)
;; <project name> is computed
;; you'll need to revert the buffer(s) to see changes
(defun fx-java-format-project ()
  (interactive)
  (bazel--compile
   "run"
   "--"
   "//build-utils/format:java"
   (fx-java-project-name buffer-file-name)))

;; toggle between main and test directories for a package (C-c t)
;; if you're in src/main/x/y/Z.java go to src/test/x/y
;; if you're in src/test/x/y/ZTest.java go to src/main/x/y
(defun fx-java-toggle-main-or-test ()
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
