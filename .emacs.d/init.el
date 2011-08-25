;; mac ctrl == emacs ctrl
;; mac alt == emacs meta
;; mac cmd == emacs alt
;; C-h f == look up any function
;; C-h a == search everything in emacs
;; C-x C-d == browse directory
;; C-x C-e == execute expression at the end of your cursor
;; C-W == closes frame

;;TODO - when i tab complete a file, i don't want it to automatically open
;;TODO - make directory browsing -alhrt style
;;TODO - emulate texmate's column select mode.
;;TODO - fuck you, tabs

;; 14:03:15 < Arkamist> look into a symbol tagging system
;; 14:03:32 < Arkamist> like xcscope or gnu global with emacs integration
;; 14:03:43 < Arkamist> and be enlightened
;; 14:03:54 < Arkamist> also sr-speedbar

;;; White space stuff
(require 'whitespace)
;; always insert an ascii TAB char when I hit the TAB button
;; i'm not sure why I have two; brett told me to use the first, 
;; http://www.xemacs.org/Links/tutorials_1.html told me to use the second
(setq-default tab-always-indent nil)
(setq-default indent-tabs-mode t)
(setq indent-tabs-mode t)
;; tabs are represented as 4 spaces
(setq default-tab-width 4)
(setq tab-width 4)
(setq c-basic-indent 4)
;; hitting backspace should delete a tab, not convert it to spaces
(setq-default c-backspace-function 'backward-delete-char)
(setq-default backward-delete-char-untabify-method nil)
;; well, if i can't figure this out...
;;(global-set-key (kbd "TAB") 'self-insert-command)

;; okay seriously when I have
;; 	public function whatever() {
;; <-- if I hit tab here, it inserts a tab, and two spaces.
;; what the fuck.


;; I want help to pop up in a new window the first time,
;; but after that, stay put forever
;; keep things in the same window
;;(setq pop-up-windows nil)
;;(add-to-list 'same-window-buffer-names "*Help*")
;;(add-to-list 'same-window-buffer-names "*Apropos*")
;;(add-to-list 'same-window-buffer-names "*Summary*")



;; C-x C-c should not fucking kill emacs
(define-key global-map (kbd "C-x C-c") 'ignore)
;; A-n (cmd-n) should open new frame
(define-key global-map (kbd "A-n") 'make-frame-command)


;; This is where my stuff lives
(setq dotfiles-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path dotfiles-dir)

;Get rid of the annoying splash and startup screens
(setq inhibit-splash-screen t
      inhibit-startup-message t)

;; I like seeing column numbers
(setq column-number-mode t)

;; color-theme, with blackboard theme, i think
(add-to-list 'load-path (concat dotfiles-dir "color-theme"))
(require 'color-theme)
(setq color-theme-is-global t
      frame-background-mode 'dark)
(color-theme-initialize)
(progn (load-file (concat dotfiles-dir "themes/blackboard.el")) 
  (color-theme-blackboard))

;; whitespace - show me trailing bullshit, and show tabs as characters
(require 'whitespace)
(whitespace-mode t)
(setq-default whitespace-style '(face tabs trailing tab-mark) )

;; php
(require 'php-mode)

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; scpaste
(require 'scpaste)
(setq scpaste-http-destination "http://paste.lishin.org"
      scpaste-scp-destination "lishin.org:/var/domains/lishin.org/scpaste")

;; ido, as recommended by brett.
;; I do not know what this does.
(setq ido-auto-merge-work-directories-length -1
      ido-case-fold t
      ido-create-new-buffer 'always
      ido-enable-flex-matching t
      ido-save-directory-list-file nil)
(require 'ido)
(ido-mode t)
(ido-everywhere t)

;; use ctrl-tab and shift-ctrl-tab to move around windows
;; like tabs in Chrome, etc.
(defun other-other-window ()
  (interactive)
  (other-window -1))
(global-set-key [(control tab)] 'other-window)
(global-set-key [(control shift tab)] 'other-other-window)


;; dear emacs, please stop shitting files everywhere
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; I dunno, man, emacs did this shit on its own when I changed my default font shit.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F8F8F8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "apple" :family "Monaco")))))

;; delete key now deletes what i have selected
(delete-selection-mode 1)

;; show me where i am in this stupid lisp
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)

;; revert changed files automatically
(global-auto-revert-mode t)

;; makes shit work like native os x apps
(require 'redo+)
(require 'mac-key-mode)
(mac-key-mode 1)

;; don't wrap long lines
(setq-default truncate-lines t)

;; I don't know what this does
(require 'imenu)

;; what are you
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; recent files list
(require 'recentf)
(recentf-mode t)
(setq recentf-max-saved-items 50)
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))




;; comment line(s)
(defun comment-or-uncomment-line (&optional lines)
  "Comment current line. Argument gives the number of lines
forward to comment"
  (interactive "P")
  (commnt-or-uncomment-region
   (lin-beginning-position)
   (lin-end-position lines)))
;; commnt region or just this line
(defun comment-or-uncomment-region-or-line (&optional lines)
  "If te line or region is not a comment, comments region
if markis active, line otherwise. If the line or region
is a comment, uncomment."
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
    (comment-or-uncomment-region (point) (mark)))
    (comment-or-uncomment-line lines)))
;; bind above to alt-#
(global-set-key [(meta ?#)] 'comment-or-uncomment-region-or-line)

;; column select
;;(setq cua-rectangle-mark-key (kbd "<f5>"))
(global-set-key (kbd "<f5>") 'cua-set-rectangle-mark)
(cua-mode t)
(setq cua-enable-cua-keys nil)

