;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-palenight)

(setq doom-font (font-spec :family "Berkeley Mono" :size 14))

(setq fill-column 100)

;; Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; (use-package! odin-mode)

;; Language-specific configurations
;;
;; Go
(let ((home-path (getenv "HOME")))
  (setq go-bin-path (concat home-path "/code/go/bin")))

(defun has-go-bin-in-path (exec-path-value)
  (if (member go-bin-path exec-path-value)
      t
      nil))

(defun append-go-bin-path ()
  (setq exec-path (append exec-path (list go-bin-path))))

(defun add-go-bin-path ()
  (if (has-go-bin-in-path exec-path)
      nil
      (append-go-bin-path)))

(add-go-bin-path)

;; (setq doom-localleader-key (kbd ","))

;; Unbind `s` as 2-character search
(define-key evil-normal-state-map (kbd "s") 'evil-substitute)

;; Set multi character search to better key
(define-key evil-normal-state-map (kbd "g/") 'evil-avy-goto-char-timer)

;; Set return as nohighlight key
(define-key evil-normal-state-map (kbd "RET") 'evil-ex-nohighlight)

;; Jump to errors/diagnostics
(map! :map evil-normal-state-map :leader "en" #'next-error)
(map! :map evil-normal-state-map :leader "ep" #'previous-error)

;; Window movement
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)

(map! :map evil-normal-state-map :leader "TAB" #'evil-switch-to-windows-last-buffer)

;; MPD bindings
(map! :map evil-normal-state-map [(XF86AudioPlay)] #'libmpdel-playback-play-pause)
(map! :map evil-normal-state-map [(XF86AudioLowerVolume)] #'mpdel-core-volume-decrease)
(map! :map evil-normal-state-map [(XF86AudioRaiseVolume)] #'mpdel-core-volume-increase)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-current-absolute t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; (require 'which-key)
(setq which-key-idle-delay 0.1)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after;!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! evil-snipe
  (evil-snipe-mode -1))

(setq-default lsp-auto-guess-root t)

(use-package! lsp)

(setq lsp-ui-peek-enable t)
(setq lsp-ui-doc-show-with-cursor t)
(setq lsp-ui-doc-position 'top)
(setq lsp-ui-sideline-show-hover nil)

(pushnew! lsp-language-id-configuration '(odin-mode . "odin") '(nim-mode . "nim"))

;; Odin
(lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "ols")
                    :major-modes '(odin-mode)
                    :server-id 'ols
                    :multi-root t)) ;; This is just so lsp-mode sends the "workspaceFolders" param to the server.
(add-hook 'odin-mode-hook #'lsp)

;; Nim
(lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "nimlangserver")
                    :major-modes '(nim-mode)
                    :server-id 'nimlangserver
                    :multi-root t)) ;; This is just so lsp-mode sends the "workspaceFolders" param to the server.
(add-hook 'nim-mode-hook #'lsp)

(setq mpdel-prefix-key (kbd "C-. z"))

;; Go
(setq gofmt-command "golines")
(setq gofmt-args '("--base-formatter=gofumpt"))

;; Auto-formatting
(setq auto-format-modes
      '((odin-mode . lsp-format-buffer)
        (go-mode . gofmt)))

(defun get-formatter-function (mode)
  (cdr (assoc mode auto-format-modes)))

(defun auto-format-buffer ()
  (let ((formatter-function (get-formatter-function major-mode)))
    (if formatter-function
        (progn
          (message
            (concat "Formatting buffer with function:" (symbol-name formatter-function)))
          (funcall formatter-function))
          
        (progn
          (message
            (concat "No formatter function found for mode:" (symbol-name major-mode)))))))


(add-hook 'before-save-hook #'auto-format-buffer)
