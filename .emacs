;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Hide menubar:
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
;; to re-enable, M-x tool-bar-mode

;; smaller tabs please
(setq-default tab-width 4)

;; No splash screen
(setq inhibit-startup-message t)

;; better bindings for window resizing
(global-set-key (kbd "M-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-C-<down>") 'shrink-window)
(global-set-key (kbd "M-C-<up>") 'enlarge-window)

;; buffer switching
(defun er-switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) nil)))
(global-set-key [f2] (quote er-switch-to-previous-buffer))

;;highlight matching parens
(progn
  (show-paren-mode 1))

;; editors should be seen, not heard
(require 'mode-line-bell)
(mode-line-bell-mode)

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)))

;; org mode
(setq org-blank-before-new-entry '((heading) (plain-list-item)))
;;(require 'ox-extra)
;;(ox-extras-activate '(ignore-headlines))
(add-hook 'org-mode-hook 'visual-line-mode)

;; text mode
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; python
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
(setq
 python-shell-interpreter "ipython3"
 python-shell-interpreter-args "--simple-prompt -i"
 elpy-rpc-python-command "python3")
 elpy-modules (delete 'elpy-module-flymake elpy-modules)
(require 'pyvenv)
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))
(add-hook 'elpy-mode-hook 'electric-pair-mode)
(add-hook 'python-mode-hook
		  (lambda ()
			(setq python-indent-offset 4)))

;; javascript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
;; autocomplete braces
(add-hook 'js2-mode-hook 'electric-pair-mode)

;; golang
(defun my-go-mode-hook ()
  ; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  ;; company mode
  (company-mode)
  (set (make-local-variable 'company-backends) '(company-go))
  (go-eldoc-setup)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-hook 'go-mode-hook 'electric-pair-mode)

;; lua
(add-hook 'lua-mode-hook 'electric-pair-mode)

;;html
;;(setq sgml-quick-keys 'close)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#01323d" "#ec423a" "#93a61a" "#c49619" "#3c98e0" "#e2468f" "#3cafa5"
	"#60767e"])
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#3cafa5")
 '(cua-normal-cursor-color "#8d9fa1")
 '(cua-overwrite-cursor-color "#c49619")
 '(cua-read-only-cursor-color "#93a61a")
 '(custom-safe-themes
   '("0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75"
	 "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9"
	 "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693"
	 "1db4be958a1df556190253eaee2717c554402f93d96ff6ec9e206567d906817e"
	 "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3"
	 "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5"
	 "e5dc5b39fecbeeb027c13e8bfbf57a865be6e0ed703ac1ffa96476b62d1fae84"
	 default))
 '(fci-rule-color "#01323d")
 '(highlight-changes-colors '("#e2468f" "#7a7ed2"))
 '(highlight-symbol-colors
   '("#3c6e408d329c" "#0c4a45f54ce3" "#486d33913531" "#1fab3bea568c"
	 "#2ec943ac3324" "#449935a6314d" "#0b03411b5985"))
 '(highlight-symbol-foreground-color "#9eacac")
 '(highlight-tail-colors
   '(("#01323d" . 0) ("#687f00" . 20) ("#008981" . 30) ("#0069b0" . 50)
	 ("#936d00" . 60) ("#a72e01" . 70) ("#a81761" . 85)
	 ("#01323d" . 100)))
 '(hl-bg-colors
   '("#936d00" "#a72e01" "#ae1212" "#a81761" "#3548a2" "#0069b0"
	 "#008981" "#687f00"))
 '(hl-fg-colors
   '("#002732" "#002732" "#002732" "#002732" "#002732" "#002732"
	 "#002732" "#002732"))
 '(hl-paren-colors '("#3cafa5" "#c49619" "#3c98e0" "#7a7ed2" "#93a61a"))
 '(lsp-ui-doc-border "#9eacac")
 '(nrepl-message-colors
   '("#ec423a" "#db5823" "#c49619" "#687f00" "#c3d255" "#0069b0"
	 "#3cafa5" "#e2468f" "#7a7ed2"))
 '(package-selected-packages
   '(afternoon-theme company-go eldoc elpy go-eldoc gotest gotham-theme
					 jedi-direx js2-mode json-mode lua-mode magit
					 markdown-mode mode-line-bell org pug-mode
					 rainbow-mode solarized-theme xresources-theme
					 zenburn-theme))
 '(pos-tip-background-color "#01323d")
 '(pos-tip-foreground-color "#9eacac")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#93a61a" "#01323d" 0.2))
 '(term-default-bg-color "#002732")
 '(term-default-fg-color "#8d9fa1")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#ec423a") (40 . "#dace73be2daa") (60 . "#d06086192512")
	 (80 . "#c49619") (100 . "#b55b9c82193d") (120 . "#ad579f3d1962")
	 (140 . "#a512a1d61994") (160 . "#9c81a44d19d1") (180 . "#93a61a")
	 (200 . "#84b6a96252b1") (220 . "#7a4caad86863")
	 (240 . "#6cbaac617d20") (260 . "#5a03adfd9174") (280 . "#3cafa5")
	 (300 . "#41c4a68fbd73") (320 . "#41d3a1f1c946")
	 (340 . "#40119d4ad513") (360 . "#3c98e0")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002732" "#01323d" "#ae1212" "#ec423a" "#687f00"
				 "#93a61a" "#936d00" "#c49619" "#0069b0" "#3c98e0"
				 "#a81761" "#e2468f" "#008981" "#3cafa5" "#8d9fa1"
				 "#60767e"))
 '(xterm-color-names
   ["#01323d" "#ec423a" "#93a61a" "#c49619" "#3c98e0" "#e2468f" "#3cafa5"
	"#faf3e0"])
 '(xterm-color-names-bright
   ["#002732" "#db5823" "#62787f" "#60767e" "#8d9fa1" "#7a7ed2" "#9eacac"
	"#ffffee"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; theme
(require 'solarized-theme)
(load-theme 'solarized-dark-high-contrast)

;; hopefully this fixes the gap in tiling mode
(setq frame-resize-pixelwise t)
