(setq inhibit-startup-message t)
(setq initial-scratch-message "In the beginning, there was darkness.")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-belt t)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-theme)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(global-set-key [remap list-buffers] 'ibuffer)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-i") 'imenu)
(global-set-key [remap dabbrev-expand] 'hippie-expand)

(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)

(setq dired-dwim-target t)

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

(load-library "xscheme")
(load-library "cheat-sh")

(windmove-default-keybindings)

(load-theme 'tango-dark)

;; set transparency
(set-frame-parameter (selected-frame) 'alpha 85)
;; (add-to-list 'default-frame-alist '(alpha 85 85))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

(use-package try
  :ensure t)

(use-package all-the-icons
  :if (display-graphic-p))

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

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(use-package general
  :config
  (general-create-definer efs/leader-keys
			  :keymaps '(normal insert visual emacs)
			  :prefix "C-c"
			  :global-prefix "C-c")

  (efs/leader-keys
   "a" 'org-agenda
   "t"  '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")
   "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package consult)
(use-package wgrep)
(use-package company)
;; (use-package embark)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))


(defhydra hydra-transparency (global-map "<f2>")
  "transparency"
  ("k" (transparency (+ (frame-parameter nil 'alpha) 1)))
  ("j" (transparency (- (frame-parameter nil 'alpha) 1))))



;; Set transparency of emacs
 (defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (if (and (>= value 0) (<= value 100))
    (progn
      (message "Transparency value: %d" value)
      (set-frame-parameter (selected-frame) 'alpha value))
     (message "Out of range 0:100")))


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/works")
    (setq projectile-project-search-path '("~/works")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))



(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
  :after magit)
(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

(use-package emmet-mode
  :hook (html-mode-hook . emmet-mode)
  :hook (lsp-mode . emmet-mode)
  :hook (css-mode-hook . emmet-mode))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (js-mode . lsp)
	 (css-mode . lsp)
	 ;; (lsp-mode . turn-on-evil-mode)
	 (lsp-mode . (lambda () (setq js-jsx-indent-level 2)))
	 (lsp-mode . (lambda () (setq js-indent-level 2)))
	 (lsp-mode . (lambda () (setq emmet-indentation 2)))
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)


;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

(use-package avy
	    :ensure t
	    :bind ("M-s" . avy-goto-char))


(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

;; (use-package zenburn-theme
;;   :ensure t
;;   :config (load-theme 'zenburn t))


(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))



  
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" default))
 '(helm-minibuffer-history-key "M-p")
 '(org-agenda-files
   '("/home/lam/workx/OrgFiles/Tasks.org" "/home/lam/workx/OrgFiles/Habits.org"))
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-directory "~/workx/orgfiles")
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded 'overview)
 '(org-startup-indented t)
 '(package-selected-packages
   '(org-pdfview pdf-tools git-timemachine git-gutter pcre2el elfeed-goodies elfeed-org elfeed better-shell noflet iedit expand-region aggressive-indent aggresive-indent hungry-delete beacon undo-tree elpy jedi flycheck ox-reveal zenburn-theme color-theme auto-complete web-mode try lsp-tailwindcss embark wgrep consult company dap-mode helm-lsp lsp-ui emmet-mode go-mode dumb-jump whole-line-or-region helm ace-jump-mode visual-fill-column org-bullets forge evil-magit magit counsel-projectile projectile hydra evil-collection evil general helpful ivy-rich which-key rainbow-delimiters all-the-icons doom-modeline counsel swiper ivy command-log-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
