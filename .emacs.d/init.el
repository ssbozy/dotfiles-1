;; 
(setq dotfiles-dir (expand-file-name "~/.emacs.d/"))

;; color-theme, with blackboard theme, i think
(add-to-list 'load-path (concat dotfiles-dir "color-theme"))
(require 'color-theme)
(color-theme-initialize)
(progn (load-file (concat dotfiles-dir "themes/blackboard.el")) 
  (color-theme-blackboard))
