;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jakub Pietrzyk"
      user-mail-address "pietrzyk.jakub001@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Ubuntu Mono" :weight 'medium  :size 18 )
      doom-variable-pitch-font (font-spec :family "Inter" :weight 'medium :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;


(defun er-indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun er-indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (er-indent-buffer)
        (message "Indented buffer.")))))

(map! :map company-active-map
      "C-l"  'company-complete-selection
      "<return>" nil
      "TAB" 'company-complete-selection
      "RET" nil)

(map! :map org-mode-map
      "C-9" 'org-previous-visible-heading
      "C-0" 'org-next-visible-heading
      "C-)" 'outline-up-heading)

(map! :leader :desc "Ace window" "w TAB" 'ace-window)
(map! :leader :desc "Indent buffer" "b =" 'er-indent-region-or-buffer)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(setq org-src-preserve-indentation t
      lsp-ui-doc-position 'bottom)

(setq org-roam-directory "/home/jakub/notes")

(setq ispell-current-dictionary "en_US")

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))

(defun trix/org-mode-setup()
  (org-indent-mode)
  (visual-line-mode 1)

  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5
                  org-level-6
                  org-level-7
                  org-level-8))
    (set-face-attribute face nil :weight 'bold :height 1.1))
  (set-face-attribute 'org-done nil :strike-through t)
  (set-face-attribute 'org-headline-done nil
                      :strike-through t
                      :foreground "#474745"))

(use-package! org
  :hook (org-mode . trix/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"))

(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("⁖"))
  )

(defun trix/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . trix/org-mode-visual-fill))

(add-to-list 'auto-mode-alist '("\\.rasi\\'". css-mode))

(setq which-key-idle-delay 0.2)

(set-frame-parameter ( selected-frame ) 'alpha '(95 . 75))
(add-to-list 'default-frame-alist '(alpha . (95 . 75)))

(global-activity-watch-mode)

(+org-pretty-mode)

(setq lua-indent-nested-block-content-align nil)

(use-package! company-box
  :hook (company-mode . company-box-mode))
