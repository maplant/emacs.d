(require 'package)
(require 'bind-key)
(require 'use-package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Package configurations:

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  :bind (:map company-active-map
	      ("C-n". company-select-next)
	      ("C-p". company-select-previous)
	      ("M-<". company-select-first)
	      ("M->". company-select-last)))

;; Remove the following section if you want inline types in rust
(use-package eglot
  :config
  (add-to-list 'eglot-ignored-server-capabilites :inlayHintProvider))

(use-package flyspell-mode
  :hook (org-mode))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("M-s g" . helm-grep-do-git-grep)
         ([f1] . helm-buffers-list)
         (:map helm-map
               ("<left>" . helm-previous-source)
               ("<right>" . helm-next-source)))
  :custom
  (helm-ff-lynx-style-map t)
  :config
  (helm-mode 1))

(use-package magit
  :ensure t)

;; We use both rust-mode and rustic to get the best of both worlds;
;; rust-format-buffer works much better than rustic's for some reason.

(use-package rust-mode
  :ensure t)

(use-package rustic
  :ensure t
  :bind (:map rust-mode-map
	      ("C-c C-r" . multi-compile-rust-run)
              ("C-c C-f" . rust-format-buffer))
  :custom
  ;; eglot as of now is a little slower to start up than lsp-mode, but
  ;; it's built in so we prefer that.
  (rustic-lsp-client 'eglot))

;; If you don't mind that as of right now Rust tree sitter does not
;; highlight doc comments, comment out rustic (and make sure it's uninstalled)
;; and bring back in the following section:

;; (use-package rust-ts-mode
;;   :bind (:map rust-ts-mode-map
;; 	      ("C-c C-r" . multi-compile-rust-run)
;;            ("C-c C-f" . rust-format-buffer))
;;   :config 
;;   (add-hook 'rust-ts-mode-hook 'eglot-ensure)
;;   (add-hook 'rust-ts-mode-hook 'company-mode))

;; Automatically prompt and install for tree sitter modes:

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt "Prompt for installation if we're missing a treesitter mode")
  :config
  (global-treesit-auto-mode))

;; Meta-n will create a new cursor below the current one (or the furthest one down).
;; multiple-cursors has a lot of fancy features so I encourage looking into them, I
;; only use this one because I'm a simpleton.

(use-package multiple-cursors
  :ensure t
  :bind (("M-n" . mc/mark-next-like-this)))

(use-package windmove
  :ensure t
  :bind (("M-<up>" . windmove-up)
         ("M-<down>" . windmove-down)
         ("M-<left>" . windmove-left)
         ("M-<right>" . windmove-right)))

;; This, in theory, should enable poly mode for Rust, where anything within
;; a r#" string will be highlighted with SQL mode. In practice, I found it
;; too slow and buggy. 

;; (use-package polymode
;;   :ensure t
;;   :mode ("\.rs$" . poly-rust-sql-mode)
;;   :config
;;   (setq polymode-prefix-key (kbd "C-c n"))
;;   (define-hostmode poly-rust-hostmode :mode 'rust-mode)

;;   (define-innermode poly-sql-expr-rust-innermode
;;     :mode 'sql-mode
;;     :head-matcher (rx "r#\"")
;;     :tail-matcher (rx "\"#")
;;     :head-mode 'host
;;     :tail-mode 'host)

;;   (define-polymode poly-rust-sql-mode
;;     :hostmode 'poly-rust-hostmode
;;     :innermodes '(poly-sql-expr-rust-innermode)))

(defun multi-compile-rust-run ()
  "Give a list of options for building or running a Rust project"
  (interactive)
  (funcall
   (helm-comp-read "Build mode: " '(("build" . rustic-cargo-build)
                                    ("test" . rustic-cargo-run-nextest)
                                    ("run" . rustic-cargo-run)
                                    ("clippy" . rustic-cargo-clippy)))))

(use-package solarized-theme
  :ensure t
  :after (dbus)
  :custom
  (solarized-distinct-fringe-background t "Make the fringe color dark.")
  (solarized-distinct-doc-face t "Make doc comments purple.")
  (solarized-emphasize-indicators t))

(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-dark-theme 'solarized-dark)
  (auto-dark-light-theme 'solarized-light)
  :config
  (auto-dark-mode t))

;; Prog mode hooks: 

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'subword-mode)

;; Global keybindings:

(bind-keys* ("<prior>" . backward-paragraph)
            ("<next>" . forward-paragraph)
            ;; Make control tab always insert a tab character
            ("C-<tab>" .  (lambda ()
                            (interactive)
                            (insert-char 9 1)
                            (untabify (- (point) 1) (point)))))

;; Custom variables:

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen -1
      custom-file (concat user-emacs-directory "/custom.el"))
(set-frame-font "Anonymous Pro 10" nil t)
