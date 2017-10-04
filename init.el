(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(eval-when-compile
  (require 'use-package))

(require 'bind-key)

;; Package configurations:

(use-package solarized-theme
  :ensure t
  :config
  (setq solarized-distinct-fringe-background t
	solarized-distinct-doc-face t
	solarized-emphasize-indicators t))

(use-package multi-compile
  :ensure t
  :config
  (setq multi-compile-alist
	'((c-mode . (("build" . "make -k")
		     ("clean" . "make clean all")))
	  (c++-mode . (("build" . "make -k")
		       ("clean" . "make clean all")))
	  (go-mode . (("build" . "go build")
		      ("run" . "go run")))
	  (rust-mode . (("build" . "cargo build --color always")
			("debug" . "cargo run --color always")
			("release" . "cargo run --release --color always")
			("test" . "cargo test --color always"))))))

(setq-default c-default-style "k&r"
	      c-basic-offset 8
	      tab-width 4
	      indent-tabs-mode nil)

(use-package rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :bind (:map rust-mode-map
	      ("C-c C-r" . multi-compile-run))
  :config
  ;; Electric indent for list closing delimeters
  (define-key rust-mode-map	(kbd "}")
    (lambda () (interactive) (insert "}") (rust-mode-indent-line)))
  (define-key rust-mode-map	(kbd ")")
    (lambda () (interactive) (insert ")") (rust-mode-indent-line)))
  (define-key rust-mode-map	(kbd "]")
    (lambda () (interactive) (insert "]") (rust-mode-indent-line)))

  ;; Custom hook for rust mode.
  (add-hook 'rust-mode-hook
	    (lambda ()
	      (nlinum-mode)
	      (subword-mode 1)
	      (set-fill-column 80)
	      (fci-mode))))

;; We can't use racer mode until emacs 26 comes out. Line numbers are just too slow.
					;(with-eval-after-load 'company
					;  (add-to-list 'company-backends 'company-racer))

					;(add-hook 'rust-mode-hook #'racer-mode)
					;(add-hook 'racer-mode-hook #'eldoc-mode)
					;(add-hook 'racer-mode-hook #'company-mode)

(defun metal-mode-hook ()
  (setq tab-width 8)
  (nlinum-mode)
  (subword-mode 1)
  (ggtags-mode)
  (set-fill-column 80)
  (fci-mode))

(use-package c-mode
  :bind (:map c-mode-map
	      ("C-c C-r" . multi-compile-run)
	      ("C-c C-d" . disaster)
	      ("[mouse-3]" . ggtags-find-tag-mouse))
  :config
  (add-hook 'c-mode-common-hook 'metal-mode-hook))

(use-package c++-mode
  :bind (:map c++-mode-map
	      ("C-c C-r" . multi-compile-run)
	      ("C-c C-d" . disaster)
	      ("[mouse-3]" . ggtags-find-tag-mouse))
  :config
  (add-hook 'c++-mode-common-hook 'metal-mode-hook))

(use-package asm-mode
  :config
  (add-hook 'asm-mode-hook
	    (lambda ()
	      (ggtags-mode)
	      (nlinum-mode))))

(use-package tex-mode
  :config
  (add-hook 'tex-mode-hook
	    (lambda ()
	      (flyspell-mode)
	      (nlinum-mode))))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter "python"
  :config
  (add-hook 'python-mode-hook
	    (lambda ()
	      (nlinum-mode))))

(use-package go-mode
  :bind (:map go-mode-map
	      ("C-c C-r" . multi-compile-run))
  :config
  (add-hook 'go-mode-hook
	    (lambda ()
	      (nlinum-mode)
	      (subword-mode 1)
	      (set-fill-column 80)
	      (fci-mode))))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-b" . helm-buffers-list)
	 ([f1] . helm-buffers-list))
  :config
  (helm-mode 1))

(use-package multiple-cursors
  :ensure t
  :bind (("M-n" . mc/mark-next-like-this)))

(use-package windmove
  :ensure t
  :bind (("M-<up>" . windmove-up)
	 ("M-<down>" . windmove-down)
	 ("M-<left>" . windmove-left)
	 ("M-<right>" . windmove-up)))

(add-hook 'emacs-lisp-mode-hook (lambda () (nlinum-mode)))

(add-hook 'eshell-preoutput-filter-functions 'ansi-color-apply)

(add-hook 'compilation-filter-hook
	  (lambda ()
	    (toggle-read-only)
	    (ansi-color-apply-on-region compilation-filter-start (point-max))
	    (toggle-read-only)))

;; Global keybindings:

(bind-keys* ("<prior>" . backward-paragraph)
	    ("<next>" . forward-paragraph)
	    ;; Make control tab always insert a tab character
	    ("C-<tab>" .  (lambda ()
			    (interactive)
			    (insert-char 9 1)
			    (untabify (- (point) 1) (point)))))

;; Emacs internal configuration:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("5900bec889f57284356b8216a68580bfa6ece73a6767dfd60196e56d050619bc" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "b81bfd85aed18e4341dbf4d461ed42d75ec78820a60ce86730fc17fc949389b2" "365d9553de0e0d658af60cff7b8f891ca185a2d7ba3fc6d29aadba69f5194c7f" "6f11ad991da959fa8de046f7f8271b22d3a97ee7b6eca62c81d5a917790a45d9" "611e38c2deae6dcda8c5ac9dd903a356c5de5b62477469133c89b2785eb7a14d" "4182c491b5cc235ba5f27d3c1804fc9f11f51bf56fb6d961f94788be034179ad" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(display-time-mode t)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(inhibit-startup-screen t)
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0f11" "#7FC1CA"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0f11" "#A8CE93"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0f11" "#899BA6"))
 '(linum-format (quote dynamic))
 '(menu-bar-mode nil)
 '(nlinum-format " %d")
 '(org-fontify-done-headline t)
 '(org-fontify-quote-and-verse-blocks t)
 '(org-fontify-whole-heading-line t)
 '(package-selected-packages
   (quote
    (helm disaster use-package doom-themes telephone-line minimap multi-compile fill-column-indicator column-marker multiple-cursors eshell-prompt-extras nlinum rust-playground company-racer company flycheck-rust flymake-rust racer cargo haskell-mode solarized-theme rust-mode magit go-mode glsl-mode ggtags cider)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(set-default-font "Anonymous Pro-12")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )