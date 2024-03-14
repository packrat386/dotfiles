(require 'magit-git)
(require 'magit-process)

(defun ghh-browse-to-repo ()
  "Opens the repo for the current project in github. WIP"
  (interactive)
  (browse-url (ghh--repo-url "origin")))

(defun ghh--repo-url (remote-name)
  (let ((remote-url (ghh--remote-url remote-name)))
    (if
     (string-match-p "^https" remote-url)
     (ghh--repo-url-https remote-url)
     (ghh--repo-url-ssh remote-url))))

(defun ghh--repo-url-https (remote-url)
  (if
   (string-match
    "^https://\\([[:alnum:]-\\.]*\\)/\\([[:alnum:]-]*\\)/\\([[:alnum:]-_\\.]*\\)\\.git$"
    remote-url)
   (ghh--repo-url-from
    (match-string 1 remote-url)
    (match-string 2 remote-url)
    (match-string 3 remote-url))
   (error (format "unrecognized URL format: %s" remote-url))))

(defun ghh--repo-url-ssh (remote-url)
  (if
   (string-match
    "^git@\\([[:alnum:]-\\.]*\\):\\([[:alnum:]-]*\\)/\\([[:alnum:]-_\\.]*\\)\\.git$"
    remote-url)
   (ghh--repo-url-from
    (match-string 1 remote-url)
    (match-string 2 remote-url)
    (match-string 3 remote-url))
   (error (format "unrecognized URL format: %s" remote-url))))

(defun ghh--repo-url-from (hostname username reponame)
  (format "https://%s/%s/%s" hostname username reponame))

(defun ghh--current-branch ()
  (magit-git-string "branch" "--show-current"))

(defun ghh--branch-upstream (name)
  (magit-git-string
   "rev-parse"
   "--abbrev-ref"
   (concat name "@{upstream}")))

(defun ghh--current-remote ()
  (let ((current-upstream (ghh--branch-upstream (ghh--current-branch))))
    (if
     current-upstream
     (car (split-string current-upstream "/"))
     (car (split-string (ghh--branch-upstream "main") "/"))))) ;; guess main

(defun ghh--remote-url (name)
  (magit-git-string "remote" "get-url" name))

(provide 'packrat386/gh-helpers)

