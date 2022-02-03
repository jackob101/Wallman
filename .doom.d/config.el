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
(setq doom-font (font-spec :family "Ubuntu Mono" :weight 'thin  :size 18 )
      doom-variable-pitch-font (font-spec :family "Inter" :weight 'thin :size 18))

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

(setq web-mode-markup-indent-offset 2
      web-mode-code-indent-offset 2
      web-mode-css-indent-offset 2
      company-idle-delay 0.0
      web-mode-enable-current-element-highlight t)

(after! flyspell
  (setq flyspell-lazy-idle-seconds .4))

(use-package! projectile
  :custom
  (add-to-list 'projectile-globally-ignored-directories '"node_modules")
  )


(use-package! web-mode
  :hook ( web-mode . emmet-mode )
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" .  web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)))

(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
          (funcall (cdr my-pair)))))

(add-hook 'web-mode-hook #'(lambda ()
                             (enable-minor-mode
                              '("\\.jsx?\\'" . prettier-js-mode))
                             (enable-minor-mode
                              '("\\.tsx?\\'" . prettier-js-mode))))

;; (use-package! typescript-mode
;;   :mode "\\.tsx?$"
;;   :hook
;;   (typescript-mode . lsp)
;;   :custom
;;   (typescript-indent-level 2))

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

(defun shell-pop ()
  "Pop up shell"
  (interactive)
  (shell "*shell-pop*"))

(add-to-list 'display-buffer-alist
             '("*shell-pop" (display-buffer-in-side-window) (side . bottom)))

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
(map! :leader :desc "Indent buffer" "b =" 'er-indent-region-or-buffer
      :leader :desc "Open shell" "o s" 'shell-pop
      :leader :desc "Go to previous note" "n r b" 'org-mark-ring-goto
      :leader :desc "Go to next error" "e f n" 'evil-next-flyspell-error
      :leader :desc "Go to previous error" "e f p" 'evil-prev-flyspell-error)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(setq org-src-preserve-indentation t
      lsp-ui-doc-position 'bottom)

(setq org-roam-directory "/home/jakub/notes")

(setq ispell-current-dictionary "en_US")

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))


(use-package! org
  :hook ((org-mode . trix/org-mode-setup)
         (org-mode . mixed-pitch-mode))
  :config
  (setq org-ellipsis " ▾"))

(after! org
  (custom-set-faces!
    '(org-level-8 :inherit outline-8 :height 1.05 :weight bold)
    '(org-level-7 :inherit outline-7 :height 1.10 :weight bold)
    '(org-level-6 :inherit outline-6 :height 1.15 :weight bold)
    '(org-level-5 :inherit outline-5 :height 1.20 :weight bold)
    '(org-level-4 :inherit outline-4 :height 1.25 :weight bold)
    '(org-level-3 :inherit outline-3 :height 1.30 :weight bold)
    '(org-level-2 :inherit outline-2 :height 1.35 :weight bold)
    '(org-level-1 :inherit outline-1 :height 1.40  :weight bold)
    '(org-document-title :underline nil)
    '(variable-pitch :family "Inter" :weight light :height 100)
    '(org-block :inherit fixed-pitch)
    '(org-code :inherit (shadow fixed-pitch))
    '(org-document-info :foreground "dark orange")
    '(org-document-info-keyword :inherit (shadow fixed-pitch))
    '(org-indent :inherit (org-hide fixed-pitch))
    '(org-link :foreground "royal blue" :underline nil)
    '(org-meta-line :inherit (font-lock-comment-face fixed-pitch))
    '(org-property-value :inherit fixed-pitch)
    '(org-special-keyword :inherit (font-lock-comment-face fixed-pitch))
    '(org-table :inherit fixed-pitch :foreground "#83a598")
    '(org-tag :inherit (shadow fixed-pitch) :weight bold :height 0.8)
    '(org-verbatim :inherit (shadow fixed-pitch))
    ))


(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("⁖"))
  )

(defun trix/org-mode-setup()
  (org-indent-mode)
  (visual-line-mode 1)
  (set-face-attribute 'org-done nil :strike-through t)
  (set-face-attribute 'org-headline-done nil
                      :strike-through t
                      :foreground "#474745"))

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

(use-package! company
  :config
  (add-to-list 'company-frontends 'company-preview-frontend))

(after! org-agenda
  (add-to-list 'org-agenda-custom-commands '("b" agenda "Today's Deadlines"
                                             ((org-agenda-span '1)
                                              (org-agenda-start-day "+0d")
                                              (org-agenda-overriding-header "Today's Tasks ")))
               (add-to-list  'org-agenda-custom-commands '("w" agenda "Today's Deadlines"
                                                           ((org-agenda-span '10)
                                                            (org-agenda-overriding-header "Week tasks")
                                                            (org-agenda-tag-filter-preset '("-repeating"))
                                                            (org-agenda-start-day "-3d"))))))


(after! org-agenda
  (add-to-list 'org-agenda-files '"~/org/todos"))

(defhydra hydra-org-motion (org-mode-map "<f4>" :color amaranth)
  "
    Org motion           ^^Info
    ---------------------------------------
    _j_: Next heading      Heading:    %s(substring-no-properties (org-get-heading))
    _k_: Previous heading  Subheading: %s(length (org-map-entries nil nil 'tree))
    "
  ("j" outline-next-visible-heading nil)
  ("k" outline-previous-visible-heading nil)
  ("q" nil "quit"))

