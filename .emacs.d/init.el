(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;Initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)
;;Disable visible scrollbar
(scroll-bar-mode -1)
;;Disable the toolbar
(tool-bar-mode -1)

;;disable tooltips
(tooltip-mode -1)
;;give some breating room
(set-fringe-mode 10)
;;disable the menu bars
(menu-bar-mode -1)

(set-face-attribute 'default nil :font "Ubuntu Mono" :height 140)

(use-package doom-themes)

(load-theme 'doom-gruvbox t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 8)))

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(eshell-mode-hook
		shell-mode-hook
		term-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package ivy
  :init (ivy-mode 1)
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-j" . ivy-next-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-prevous-line)
	 ("C-d" . ivy-reverse-i-search-kill)))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package company
  :init
  (setq company-idle-delay 0.5
	company-global-modes '(not org-mode slack-mode)
	company-minimum-prefix-length 1)
  :bind(
	:map company-mode-map
	("C-;" . 'company-capf)
	:map company-active-map
	("ESC" . 'company-abort)
	("C-l" . 'company-complete-selection)
  )
  :hook ( lsp-mode . company-mode)
  :hook ( emacs-lisp-mode . company-mode)
)

(use-package lsp-mode
  :hook (
	 (js-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-completion-enable-additional-text-edit nil)
)

(add-hook 'java-mode-hook #'lsp-deferred)

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package lsp-ui)

(use-package lsp-java
  :init
  (add-hook 'java-mode-hook `lsp)
  (setq lsp-java-vmargs
	(list
	 "-XX:+UseG1GC"
	 "-XX:+UseStringDeduplication"
	 "-javaagent:/home/jakub/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar"
	 )

	;; Don't organise imports on save
	lsp-java-save-action-organize-imports nil

	;; Fetch less results from the Eclipse server
	lsp-java-completion-max-results 20

	;; Currently (2019-04-24), dap-mode works best with Oracle
	;; JDK, see https://github.com/emacs-lsp/dap-mode/issues/31
	;;
	;; lsp-java-java-path "~/.emacs.d/oracle-jdk-12.0.1/bin/java"
	lsp-java-java-path "/usr/lib/jvm/java-11-openjdk/bin/java"
	)
  )

(require 'lsp-java-boot)

;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

(use-package dap-java
  :ensure nil
  :after (lsp-java))

(use-package flycheck)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom (
	   (projectile-switch-project-action 'neotree-projectile-action)
	   (projectile-completion-system 'ivy))
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package hydra)

(use-package yasnippet
  :config (yas-global-mode))

(use-package elisp-format)

(use-package helm-lsp)
(use-package helm
  :config (helm-mode))

(use-package dashboard
  :init
  (setq dashboard-items '((recents . 5)
			  (agenda . 5 )
			  (bookmarks . 3)
			  (projects . 10)
			  (registers . 3)))
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-center-content t)
  (dashboard-startup-banner 'logo)
  (dashboard-projects-backend 'projectile)
  :bind(
	:map dashboard-mode-map
	("C-l" . dashboard-return)
	))

(setq initial-buffer-choice (lambda() (get-buffer "*dashboard*")))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(use-package general

  :config

  (general-create-definer trix/leader-keys
    :keymaps 'override
    :states 'normal
    :prefix "SPC"
    )

  (trix/leader-keys
    "b" '(:ignore t :which-key "Buffer")
    "bb" '(counsel-switch-buffer :which-key "Switch buffer")
    "bh" '(previous-buffer :which-key "Previous buffer")
    "bl" '(next-buffer :which-key "Next buffer")
    "f" '(:ignore t :which-key "File")
    "ff" '(counsel-find-file :which-key "Find file")
    "fs" '(save-buffer :which-key "Save file")
    "p" '(:keymap projectile-command-map :which-key "Projectile")
    ))

					;workspace
(trix/leader-keys
  :keymaps 'lsp-mode-map
  "w" '(:ignore t :which-key "Workspace")
  "ws" '(lsp-ivy-workspace-symbol :which-key "Symbols"))


(trix/leader-keys
  :keymaps 'java-mode-map
  "j" '(:ignore t :which-key "Java")
  "jv" '(lsp-java-assign-statement-to-local :which-key "Assign to variable")
  "ji" '(:ignore t :which-key "Imports")
  "jii" '(lsp-java-add-import :which-key "Import")
  "jio" '(lsp-java-organize-imports :which-key "Organize Imports")
  "jg" '(:ignore t :which-key "Generate")
  "jgg" '(lsp-java-generate-getters-and-setters :which-key "Getters & Setters")
  "jge" '(lsp-java-generate-equals-and-hash-code :which-key "Equals & Hash code")
  "jgs" '(lsp-java-generate-to-string :which-key "To string")
  "jgo" '(lsp-java-generate-overrides :which-key "Overrides"))


(general-define-key
 :keymaps 'helm-map
 "C-l" 'helm-toggle-visible-mark
 "C-a" 'helm-toggle-all-marks
 "C-k" 'helm-previous-line
 "C-j" 'helm-next-line)

(general-define-key
 "<f6>" 'lsp-treemacs-errors-list
 "<f7>" 'lsp-treemacs-symbols)

(global-set-key [f8] 'treemacs)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;;Neotree keybindings
  (evil-define-key 'normal neotree-mode-map (kbd "j") 'neotree-next-line)
  (evil-define-key 'normal neotree-mode-map (kbd "k") 'neotree-previous-line)
  (evil-define-key 'normal neotree-mode-map (kbd "l") 'neotree-enter)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

(use-package treemacs-all-the-icons)
(use-package lsp-treemacs
  :init
  (treemacs-load-theme 'all-the-icons)
  :custom
  (treemacs-collapse-dirs 5)
  (treemacs-width-is-initially-locked nil)
  (lsp-treemacs-sync-mode 1)
  (treemacs-indentation '(10 px)))

(use-package treemacs-evil)

(org-babel-do-load-languages 'org-babel-load-languages '((emacs-lisp . t)))
