export PATH=/usr/local/bin:$PATH
export PATH=~/.local/bin:$PATH
export EDITOR=emacs
unset COLORTERM

alias l='ls'
alias ll='ls -al'
alias e='emacs'

# brew env vars
if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# OSX
if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
fi

# Linux
if [ -f /usr/local/share/chruby/chruby.sh ]; then
   source /usr/local/share/chruby/chruby.sh
fi

chruby $(chruby | grep -E -o '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | sort -V -r | head -n 1)

# It's go time
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PATH=$PATH:~/bin

man() {
  local man_prog
  read -d '' man_prog <<ELISP
(progn
  (defun missing-man-hook ()
    (if
     (and
      (derived-mode-p 'Man-mode)
      (= (buffer-size) 0))
     (let
         ((not-found-msg
           (if (string-match-p "-k " Man-arguments)
               (format "%s: no matches" Man-arguments)
               (format "Can't find the %s manpage" (Man-page-from-arguments Man-arguments))))
          (not-found-buf (generate-new-buffer "*Man NOT FOUND*")))
       (with-current-buffer
           not-found-buf
         (progn
           (insert not-found-msg)
           (Man-mode)
           (setq-local Man-columns (Man-columns))
           (display-buffer not-found-buf)
           (delete-other-windows (get-buffer-window not-found-buf)))))))

  (add-hook 'kill-buffer-hook 'missing-man-hook)

  (defun quit-man-buffer ()
    (interactive)
    (remove-hook 'kill-buffer-query-functions #'process-kill-buffer-query-function)
    (quit-window t)
    (if (not (match-buffers
              (lambda (buffer-name)
                (with-current-buffer buffer-name
                  (derived-mode-p 'Man-mode)))))
        (save-buffers-kill-emacs)))

  (man "${@}")
  (setq confirm-kill-processes nil)
  (keymap-set Man-mode-map "q" 'quit-man-buffer)
  (let
      ((man-buffer (car (match-buffers "man ${@}"))))
    (display-buffer man-buffer)
    (delete-other-windows (get-buffer-window man-buffer))))
ELISP

  emacs --eval "${man_prog}"
}

# load sk
[ -s /opt/homebrew/opt/sk/share/sk/sk.sh ] && . /opt/homebrew/opt/sk/share/sk/sk.sh

export PS1="  [\h] \W > "

# load employer specific stuff last
[ -s ~/.employer/bashrc ] && \. ~/.employer/bashrc
