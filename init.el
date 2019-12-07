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
  :hook ((asm-mode cc-mode go-mode python-mode rust-mode) . fci-mode))

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
           :sitemap-filename "sitemap.org"
           :sitemap-titile "Sitemap")
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
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :bind (:map rust-mode-map
	            ("C-c C-r" . multi-compile-rust-run))
  :hook (rust-mode . custom-prog-mode)
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

(defun custom-prog-mode ()
  (display-line-numbers-mode)
  (flyspell-prog-mode)
  (set-fill-column 80)
  (subword-mode 1))

(defun multi-compile-rust-run ()
  (interactive)
  (funcall
   (helm-comp-read "Build mode: " '( ("build" . cargo-process-build)
                                    ("test" . cargo-process-test)))))

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" default)))
 '(helm-ff-lynx-style-map t t nil "Customized with use-package helm")
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(multi-compile-alist
   (quote
    ((c-mode
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
      ("test" . "cargo test --color always")))) nil nil "Customized with use-package multi-compile")
 '(package-selected-packages
   (quote
    (cargo multiple-cursors ggtags yasnippet solarized-theme rust-mode multi-compile magit lsp-mode lsp-ui helm use-package gnu-elpa-keyring-update)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(solarized-distinct-doc-face t nil nil "Make doc comments purple.")
 '(solarized-distinct-fringe-background t nil nil "Make the fringe color dark.")
 '(solarized-emphasize-indicators t nil nil "Customized with use-package solarized-theme")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
