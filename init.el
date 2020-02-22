;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org hlinum gotest flycheck go-rename company-go company magit xclip yaml-mode markdown-mode projectile go-mode dakrone-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'newcomment)
(setq comment-auto-fill-only-comments 1)
(setq-default auto-fill-function 'do-auto-fill)

;;-----------------------------------------------------------------------------
;; set look and feel.
;;-----------------------------------------------------------------------------

(load-theme 'dakrone t)

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (toggle-scroll-bar -1)))

(menu-bar-mode -1)
;; (toggle-scroll-bar -1)
;; (tool-bar-mode -1)

(require 'hlinum)
(hlinum-activate)

(global-linum-mode t)
(setq linum-format "%d ")

;;-----------------------------------------------------------------------------
;; disable backups/lock files/etc.
;;-----------------------------------------------------------------------------

(setq make-backup-file nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;;-----------------------------------------------------------------------------
;; set tab behaviour.
;;-----------------------------------------------------------------------------

(global-set-key (kbd "TAB") 'self-insert-command);

(setq-default tab-width 4)
(setq-default c-default-style "linux")
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)

;;-----------------------------------------------------------------------------
;; go-mode configuration and keybinds
;;-----------------------------------------------------------------------------

(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq gofmt-command "goimports")
  (let ((map go-mode-map))
	(define-key map (kbd "C-c a") 'go-test-current-project)
    (define-key map (kbd "C-c m") 'go-test-current-file)
    (define-key map (kbd "C-c .") 'go-test-current-test)
    (define-key map (kbd "C-c b") 'go-run))
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook (lambda ()
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)))

;;-----------------------------------------------------------------------------
;; Projectile keybinds for things like fuzzy search.
;;-----------------------------------------------------------------------------

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;-----------------------------------------------------------------------------
;; Kill other buffers that are started normally.
;;-----------------------------------------------------------------------------

(setq inhibit-startup-screen t
      initial-buffer-choice  nil)

;;-----------------------------------------------------------------------------
;; Enable clipboard.
;;-----------------------------------------------------------------------------

;; (xclip-mode 1)

;;-----------------------------------------------------------------------------
;; Org mode.
;;-----------------------------------------------------------------------------

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)
