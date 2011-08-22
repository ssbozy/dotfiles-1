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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F8F8F8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "apple" :family "Monaco")))))
