;; This is where my stuff lives
(setq dotfiles-dir (expand-file-name "~/.emacs.d/"))

;Get rid of the annoying splash and startup screens
(setq inhibit-splash-screen t
      inhibit-startup-message t)


;; color-theme, with blackboard theme, i think
(add-to-list 'load-path (concat dotfiles-dir "color-theme"))
(require 'color-theme)
(setq color-theme-is-global t
      frame-background-mode 'dark)
(color-theme-initialize)
(progn (load-file (concat dotfiles-dir "themes/blackboard.el")) 
  (color-theme-blackboard))
