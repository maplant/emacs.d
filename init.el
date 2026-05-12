;;; init.el --- -*- lexical-binding: t -*-

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(require 'bind-key)
(require 'use-package)
(setq use-package-always-ensure t)

;; UI / behavior:

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t
      column-number-mode t
      custom-file (make-temp-file "emacs-custom-")
      custom-safe-themes t
      initial-frame-alist (append initial-frame-alist
                                  '((width . 0.5))))

(setq-default indent-tabs-mode nil)
(set-frame-font "Anonymous Pro-12" nil t)

;; Helper functions:

(defun multi-compile-rust-run ()
  "Give a list of options for building or running a Rust project."
  (interactive)
  (let* ((choices '(("build"  . rustic-cargo-build)
                    ("test"   . rustic-cargo-test)
                    ("run"    . rustic-cargo-run)
                    ("bench"  . rustic-cargo-bench)
                    ("doc"    . rustic-cargo-doc)
                    ("clippy" . rustic-cargo-clippy)))
         (choice (completing-read "Build mode: " choices nil t)))
    (call-interactively (cdr (assoc choice choices)))))

;; Package configurations:

(use-package corfu
  :hook (prog-mode . corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 1)
  (corfu-quit-no-match 'separator))

(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider))

(use-package flyspell
  :ensure nil
  :hook (org-mode . flyspell-mode))

(use-package vertico
  :custom
  (vertico-scroll-margin 0)
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET"   . vertico-directory-enter)
              ("DEL"   . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)
         ("M-s g" . consult-ripgrep)
         ("M-s l" . consult-line)))

(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package magit)

;; We use both rust-mode and rustic to get the best of both worlds;
;; rust-format-buffer works much better than rustic's for some reason.

(use-package rust-mode)

(use-package rustic
  :bind (:map rust-mode-map
              ("C-c C-r" . multi-compile-rust-run)
              ("C-c C-f" . rust-format-buffer))
  :custom-face
  (rustic-compilation-column  ((t (:inherit compilation-column-number))))
  (rustic-compilation-line    ((t (:inherit compilation-line-number))))
  (rustic-message             ((t (:inherit compilation-message-face))))
  (rustic-compilation-error   ((t (:inherit compilation-error))))
  (rustic-compilation-warning ((t (:inherit compilation-warning))))
  (rustic-compilation-info    ((t (:inherit compilation-info))))
  :custom
  (compilation-scroll-output 'first-error)
  (rustic-lsp-client 'eglot))

;; Meta-n will create a new cursor below the current one (or the furthest one down).
;; multiple-cursors has a lot of fancy features so I encourage looking into them, I
;; only use this one because I'm a simpleton.

(use-package multiple-cursors
  :bind (("M-n" . mc/mark-next-like-this)))

(use-package windmove
  :ensure nil
  :bind (("M-<up>"    . windmove-up)
         ("M-<down>"  . windmove-down)
         ("M-<left>"  . windmove-left)
         ("M-<right>" . windmove-right)))

(use-package solarized-theme
  :custom
  (solarized-distinct-fringe-background t)
  (solarized-distinct-doc-face t)
  (solarized-emphasize-indicators t)
  :config
  (load-theme 'solarized-selenized-black t))

(use-package auto-dark
  :after solarized-theme
  :custom
  (auto-dark-themes '((solarized-selenized-black) (solarized-selenized-white)))
  :config
  (auto-dark-mode t))

(use-package string-inflection
  :bind (("C-c i" . string-inflection-cycle)))

(add-hook 'prog-mode-hook 'subword-mode)
(global-display-line-numbers-mode)

;; Global keybindings:

(bind-keys* ("<prior>" . backward-paragraph)
            ("<next>"  . forward-paragraph)
            ;; Make control tab always insert a tab character
            ("C-<tab>" . (lambda ()
                           (interactive)
                           (insert-char 9 1)
                           (untabify (- (point) 1) (point)))))
