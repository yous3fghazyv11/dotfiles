;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; elpaca
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents

    
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil
  :config
  (evil-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi-deuteranopia))
 '(package-selected-packages
   '(clang-format dap-mode evil good-scroll key-chord ligature lsp-ivy
                  lsp-mode lsp-treemacs lsp-ui)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; options
(setq inhibit-startup-message t)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(add-hook 'after-init-hook (lambda ()
                             (setq display-line-numbers 'relative)
                             (global-display-line-numbers-mode 1)))
(setq-default indent-tabs-mode nil)  ;; Disable tabs (use spaces instead)
(setq-default tab-width 4)           ;; Set tab width to 4 spaces
(setq-default standard-indent 4)     ;; Set standard indentation to 4 spaces

;; Scroll one line at a time
;;(setq scroll-step 1)
;;(setq scroll-conservatively 10000)
;;(setq auto-window-vscroll nil) ;; optional: disables auto vertical adjustment
;;(setq auto-window-vscroll nil)         ;; prevent automatic vertical scrolling adjustment
;;(setq scroll-margin 20)                ;; like scrolloff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; line numbers
(use-package key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)

(evil-set-undo-system 'undo-redo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; font
(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font Mono" :height 119 :weight 'normal)
(defvar ligatures-JetBrainsMono
  '("--" "---" "==" "===" "!=" "!==" "=!=" "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++"
    "!!" "??" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<>" "<<<" ">>>" "<<" ">>" "||" "-|"
    "_|_" "|-" "||-" "|=" "||=" "##" "###" "####" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:"
    "#!" "#=" "^=" "<$>" "<$" "$>" "<+>" "<+ +>" "<*>" "<* *>" "</" "</>" "/>" "<!--"
    "<#--" "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>" "==>" "=>"
    "=>>" ">=>" ">>=" ">>-" ">-" ">--" "-<" "-<<" ">->" "<-<" "<-|" "<=|" "|=>" "|->" "<-"
    "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~" "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]"
    "|>" "<|" "||>" "<||" "|||>" "|||>" "<|>" "..." ".." ".=" ".-" "..<" ".?" "::" ":::"))
(use-package ligature
  :load-path "<https://github.com/mickeynp/ligature.el.git>"
  :config
  (ligature-set-ligatures 'prog-mode ligatures-JetBrainsMono)
  (global-ligature-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; keybindings
(defun my/evil-scroll-down-and-center ()
  (interactive)
  (evil-scroll-down nil)
  (recenter))

(defun my/evil-scroll-up-and-center ()
  (interactive)
  (evil-scroll-up nil)
  (recenter))
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-d") #'my/evil-scroll-down-and-center)
  (define-key evil-normal-state-map (kbd "C-u") #'my/evil-scroll-up-and-center))
(define-key evil-visual-state-map (kbd "C-d") #'my/evil-scroll-down-and-center)
(define-key evil-visual-state-map (kbd "C-u") #'my/evil-scroll-up-and-center)

(with-eval-after-load 'evil
  ;; Normal state mappings
  (define-key evil-normal-state-map (kbd "C-a") 'evil-first-non-blank)
  (define-key evil-normal-state-map (kbd "C-e") 'end-of-line)
  ;; Visual state mappings
  (define-key evil-visual-state-map (kbd "C-a") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "C-e") 'end-of-line))
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; eshell
(defvar my/eshell-buffer-name "*eshell*")

(defun my/toggle-eshell ()
  "Toggle between current buffer and eshell."
  (interactive)
  (if (string= (buffer-name) my/eshell-buffer-name)
      ;; If already in eshell, switch back
      (if (other-buffer)
          (switch-to-buffer (other-buffer)))
    ;; If not in eshell, go there (create if needed)
    (if (get-buffer my/eshell-buffer-name)
        (switch-to-buffer my/eshell-buffer-name)
      (eshell))))
(global-set-key (kbd "C-c e") #'my/toggle-eshell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; clang-format
(use-package clang-format)
(require 'clang-format)
(setq clang-format-executable "/usr/bin/clang-format")
(setq clang-format-style "file")
(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook." 
  (add-hook 'before-save-hook (lambda () 
    (when (locate-dominating-file "." ".clang-format") 
      (clang-format-buffer)) nil) nil t))

(defun add-clang-format-hook () 
  (add-hook 'before-save-hook 'clang-format-this-buffer nil t))          

(add-hook 'c++-mode-hook
  (lambda () (clang-format-save-hook-for-this-buffer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; lsp
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
