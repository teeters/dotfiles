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

;; show recent files on startup
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(add-hook 'after-init-hook 'recentf-open-files)
(setq initial-buffer-choice 'recentf-open-files)

;; org mode
(setq org-blank-before-new-entry '((heading) (plain-list-item)))
;;(require 'ox-extra)
;;(ox-extras-activate '(ignore-headlines))
(setq org-export-allow-bind-keywords t)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-indent-mode)

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
 '(TeX-view-program-list '(("Okular" ("okular") "")))
 '(TeX-view-program-selection
   '(((output-dvi has-no-display-manager) "dvi2tty")
	 ((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi")
	 (output-pdf "PDF Tools") (output-html "xdg-open")))
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(custom-safe-themes
   '("00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c"
	 "09b833239444ac3230f591e35e3c28a4d78f1556b107bafe0eb32b5977204d93"
	 "b49f66a2e1724db880692485a5d5bcb9baf28ed2a3a05c7a799fa091f24321da"
	 "d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36"
	 "2b0fcc7cc9be4c09ec5c75405260a85e41691abb1ee28d29fcd5521e4fca575b"
	 "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1"
	 "7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
	 "adb2c32015c42ac06e4cadc87796c6255d7f7d107a2a5f9650672fe90fedd244"
	 "6f177b9a2579197e650918c8e53440997063b543fc854763e3597b5a4c33860d"
	 "afde6368be6868e8e3dd53fad1ac51223d5484f9e6836496e7987802c9a9663d"
	 "a60b04e5c0fef30209f9576f04651938472b57cb1dae0375d80a53a78f515f69"
	 "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75"
	 "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9"
	 "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693"
	 "1db4be958a1df556190253eaee2717c554402f93d96ff6ec9e206567d906817e"
	 "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3"
	 "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5"
	 "e5dc5b39fecbeeb027c13e8bfbf57a865be6e0ed703ac1ffa96476b62d1fae84"
	 default))
 '(package-selected-packages
   '(afternoon-theme auctex company-go eldoc elpy go-eldoc gotest
					 gotham-theme jedi-direx js2-mode json-mode
					 lua-mode magit markdown-mode mode-line-bell
					 olivetti org org-contrib poet-theme pug-mode
					 rainbow-mode solarized-theme xresources-theme
					 zenburn-theme)))
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
