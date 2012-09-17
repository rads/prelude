; Editor
; ===============================================================================

; Theme
; -------------------------------------------------

(set-face-attribute 'default nil :family "Consolas" :height 200)
(load-theme 'solarized-light t)

(add-hook 'prog-mode-hook 'prelude-turn-off-whitespace t)
(setq-default line-spacing 4)
(scroll-bar-mode -1)

; Evil Mode (VIM bindings)
; -------------------------------------------------

(setq evil-want-C-u-scroll t)
(require 'evil)
(require 'evil-leader)
(evil-leader/set-leader ",")
(evil-mode 1)

; Line Comment Banners
; -------------------------------------------------

(require 'line-comment-banner)
(defun fifty-banner ()
  (interactive)
  (line-comment-banner 50))

; YASnippet
; -------------------------------------------------

(defun shk-yas/helm-prompt (prompt choices &optional display-fn)
    "Use helm to select a snippet. Put this into `yas/prompt-functions.'"
    (interactive)
    (setq display-fn (or display-fn 'identity))
    (if (require 'helm-config)
        (let (tmpsource cands result rmap)
          (setq cands (mapcar (lambda (x) (funcall display-fn x)) choices))
          (setq rmap (mapcar (lambda (x) (cons (funcall display-fn x) x)) choices))
          (setq tmpsource
                (list
                 (cons 'name prompt)
                 (cons 'candidates cands)
                 '(action . (("Expand" . (lambda (selection) selection))))
                 ))
          (setq result (helm-other-buffer '(tmpsource) "*helm-select-yasnippet"))
          (if (null result)
              (signal 'quit "user quit!")
            (cdr (assoc result rmap))))
      nil))

(setq yas/prompt-functions '(shk-yas/helm-prompt))

; Languages
; ===============================================================================

; CoffeeScript
; -------------------------------------------------

(when (and (require 'flymake nil t)
           (require 'flymake-coffeescript nil t)
           (executable-find flymake-coffeescript-command))
  (add-hook 'coffee-mode-hook 'flymake-coffeescript-load))

; SASS/SCSS
; -------------------------------------------------

(setq scss-sass-command "~/.rbenv/shims/sass")
(add-hook 'scss-mode-hook 'flymake-mode)

; HTML
; -------------------------------------------------

(defun flymake-html-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "tidy" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html$\\|\\.ctp" flymake-html-init))

(add-to-list 'flymake-err-line-patterns
             '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
               nil 1 2 4))

(add-hook 'html-mode-hook 'flymake-mode)

; Bindings
; ===============================================================================

(global-set-key (kbd "C-s-;") 'fifty-banner)
(global-set-key (kbd "C-x f") 'prelude-recentf-ido-find-file)
(global-set-key [C-tab] 'other-window)
(global-set-key (kbd "C-s-u") 'universal-argument)
