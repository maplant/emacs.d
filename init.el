(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(eval-when-compile
  (require 'use-package))

(require 'bind-key)

;; Package configurations:

(use-package antlr
  :mode ("\\.g4\\'" . antlr-mode))

(use-package asm-mode
  :hook (asm-mode-hook . custom-prog-mode))

(use-package cargo
  :ensure t)

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  :bind
  (:map company-active-map
	      ("C-n". company-select-next)
	      ("C-p". company-select-previous)
	      ("M-<". company-select-first)
	      ("M->". company-select-last)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package cc-mode
  :bind (:map c-mode-map
              ("C-c C-r" . multi-compile-run)
              ("C-c C-d" . disaster)
              ("[mouse-3]" . ggtags-find-tag-mouse))
  :hook (cc-mode . custom-prog-mode)
  :config
  (c-set-offset 'innamespace 0)
  (c-set-offset 'inextern-lang 0))

(use-package css-mode
  :hook (css-mode-hook . display-line-numbers-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package fill-column-indicator
  :ensure t
  :hook ((asm-mode cc-mode go-mode python-mode) . fci-mode))

(use-package flyspell-mode
  :hook (org-mode))

(use-package go-mode
  :bind (:map go-mode-map
              ("C-c C-r" . multi-compile-run))
  :hook (go-mode . custom-prog-mode))

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

(use-package lsp-ui
  :ensure t)

(use-package lsp-mode
  :ensure t
  :after yasnippet
  :hook (rust-mode . lsp))

(use-package magit
  :ensure t)

(use-package multi-compile
  :ensure t
  :custom
  (multi-compile-alist
   '((c-mode . (("build" . "make -k")
                ("clean" . "make clean all")))
     (c++-mode . (("build" . "make -k")
                  ("clean" . "make clean all")))
     (go-mode . (("build" . "go build")
                 ("run" . "go run"))))))

(use-package org
  :bind (:map org-mode-map
              ("C-c C-r" . org-publish-project))
  :config
  (require 'ox-publish)
  (setq org-publish-project-alist
        '(
          ("org-notes"
           :base-directory "~/prog/blog/org/"
           :base-extension "org"
           :publishing-directory "~/prog/blog/publish"
           :recursive t
           :publishing-function org-html-publish-to-html
           :headline-levels 4
           :auto-preamble t
           :auto-sitemap t
           :html-wrap-src-lines t)
          ;:sitemap-filename "sitemap.org"
          ;:sitemap-titile "Sitemap")
          ("org-latex"
           :base-directory "~/prog/blog/org"
           :base-extension "tex"
           :publishing-directory "~/prog/blog/org"
           :publishing-function publish-latex-file)
          ("org-static"
           :base-directory "~/prog/blog/org"
           :base-extension "html\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|ogg\\|flac"
           :publishing-directory "~/prog/blog/publish"
           :recursive t
           :publishing-function org-publish-attachment)
          ("org"
           :components ("org-notes" "org-latex" "org-static")))))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter "python"
  :hook (python-mode . custom-prog-mode))

(use-package rust-mode
  :ensure t)

(use-package rustic
  :ensure t
  :mode ("\\.rs\\'" . rustic-mode)
  :bind (:map rust-mode-map
	            ("C-c C-r" . multi-compile-rust-run)
              ("C-c C-f" . rust-format-buffer))
  :hook (rustic-mode . custom-prog-mode)
  :after lsp-mode)

(use-package solarized-theme
  :ensure t
  :custom
  (solarized-distinct-fringe-background t "Make the fringe color dark.")
  (solarized-distinct-doc-face t "Make doc comments purple.")
  (solarized-emphasize-indicators t))

(use-package yasnippet
  :ensure t)

(setq-default c-default-style "k&r"
              c-basic-offset 2
              tab-width 2
              indent-tabs-mode nil)

(use-package ggtags
  :ensure t)

(use-package tex-mode
  :config
  (add-hook 'tex-mode-hook
	        (lambda ()
	          (flyspell-mode)
	          (display-line-numbers-mode))))

(defun publish-latex-file (_plist filename pub-dir)
  (call-process "pdflatex" nil nil nil filename))

(use-package multiple-cursors
  :ensure t
  :bind (("M-n" . mc/mark-next-like-this)))

(use-package windmove
  :ensure t
  :bind (("M-<up>" . windmove-up)
         ("M-<down>" . windmove-down)
         ("M-<left>" . windmove-left)
         ("M-<right>" . windmove-right)))

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

(defun custom-prog-mode ()
  (display-line-numbers-mode)
;  (flyspell-prog-mode)
  (set-fill-column 80)
  (column-number-mode)
  (subword-mode 1))

(defun multi-compile-rust-run ()
  (interactive)
  (funcall
   (helm-comp-read "Build mode: " '( ("build" . rustic-cargo-build)
                                     ("test" . rustic-cargo-run-nextest)
                                     ("run" . rustic-cargo-run)))))

(add-hook 'emacs-lisp-mode-hook (lambda () (display-line-numbers-mode)))

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

(setq lsp-rust-server 'rust-analyzer)

(defun set-emacs-frames (variant)
  (dolist (frame (frame-list))
    (let* ((window-id (frame-parameter frame 'outer-window-id))
	   (id (string-to-number window-id))
	   (cmd (format "xprop -id 0x%x -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"%s\""
			id variant)))
      (call-process-shell-command cmd))))

(defun set-emacs-theme-light ()
  (interactive)
  (load-theme 'solarized-light t)
  (set-emacs-frames "light"))

(defun set-emacs-theme-dark ()
  (interactive)
  (load-theme 'solarized-dark t)
  (set-emacs-frames "dark"))

(if (window-system)
    (set-emacs-theme-dark))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes '(solarized-dark))
 '(custom-safe-themes
   '("fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" default))
 '(fci-rule-color "#073642")
 '(helm-ff-lynx-style-map t nil nil "Customized with use-package helm")
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   '("#3b6b40f432d6" "#07b9463c4d36" "#47a3341e358a" "#1d873c3f56d5" "#2d86441c3361" "#43b7362d3199" "#061d417f59d7"))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   '(("#073642" . 0)
     ("#5b7300" . 20)
     ("#007d76" . 30)
     ("#0061a8" . 50)
     ("#866300" . 60)
     ("#992700" . 70)
     ("#a00559" . 85)
     ("#073642" . 100)))
 '(hl-bg-colors
   '("#866300" "#992700" "#a7020a" "#a00559" "#243e9b" "#0061a8" "#007d76" "#5b7300"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-paren-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(inhibit-startup-screen t)
 '(jdee-db-active-breakpoint-face-colors (cons "#073642" "#268bd2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#073642" "#859900"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#073642" "#56697A"))
 '(lsp-ui-doc-border "#93a1a1")
 '(menu-bar-mode nil)
 '(multi-compile-alist
   '((c-mode
      ("build" . "make -k")
      ("clean" . "make clean all"))
     (c++-mode
      ("build" . "make -k")
      ("clean" . "make clean all"))
     (go-mode
      ("build" . "go build")
      ("run" . "go run"))
     (rust-mode
      ("build" . "cargo build --color always")
      ("debug" . "cargo run --color always")
      ("release" . "cargo run --release --color always")
      ("bench" . "cargo bench --color always")
      ("test" . "cargo test --color always"))) nil nil "Customized with use-package multi-compile")
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4"))
 '(objed-cursor-color "#dc322f")
 '(package-selected-packages
   '(rustic typescript-mode protobuf-mode glsl-mode handlebars-mode doom-themes yaml-mode cargo multiple-cursors ggtags yasnippet solarized-theme multi-compile magit lsp-mode lsp-ui helm use-package gnu-elpa-keyring-update))
 '(pdf-view-midnight-colors (cons "#839496" "#002b36"))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(rustic-ansi-faces
   ["#002b36" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(scroll-bar-mode nil)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(solarized-distinct-doc-face t nil nil "Make doc comments purple.")
 '(solarized-distinct-fringe-background t nil nil "Make the fringe color dark.")
 '(solarized-emphasize-indicators t nil nil "Customized with use-package solarized-theme")
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#dc322f")
     (40 . "#cb4366eb20b4")
     (60 . "#c1167942154f")
     (80 . "#b58900")
     (100 . "#a6ae8f7c0000")
     (120 . "#9ed892380000")
     (140 . "#96be94cf0000")
     (160 . "#8e5397440000")
     (180 . "#859900")
     (200 . "#77679bfc4635")
     (220 . "#6d449d465bfd")
     (240 . "#5fc09ea47092")
     (260 . "#4c68a01784aa")
     (280 . "#2aa198")
     (300 . "#303498e7affc")
     (320 . "#2fa1947cbb9b")
     (340 . "#2c879008c736")
     (360 . "#268bd2")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#839496" "#657b83"))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Anonymous Pro" :foundry "mlss" :slant normal :weight normal :height 102 :width normal)))))
