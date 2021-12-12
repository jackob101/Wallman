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
(setq doom-font (font-spec :family "Ubuntu Mono" :size 18 )
       doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

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

(map! :map company-active-map
      "C-l"  'company-complete-selection
      "<return>" nil
      "TAB" 'company-complete-selection
      "RET" nil)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(setq org-src-preserve-indentation t)

(defun trix/org-mode-setup()
  (org-indent-mode)
  (visual-line-mode 1))

(dolist (face '((org-level-1 . 1.14)
                (org-level-2 . 1.12)
                (org-level-3 . 1.10)
                (org-level-4 . 1.08)
                (org-level-5 . 1.06)
                (org-level-6 . 1.04)
                (org-level-7 . 1.02)
                (org-level-8 . 1.0)))
  (set-face-attribute (car face) nil :font "Ubuntu mono" :weight 'regular :height (cdr face)))

(use-package! org
  :hook (org-mode . trix/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"))

(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  )

(defun trix/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . trix/org-mode-visual-fill))

(add-to-list 'auto-mode-alist '("\\.rasi\\'". css-mode))

(setq which-key-idle-delay 0.2)
