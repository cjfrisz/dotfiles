;;----------------------------------------------------------------------
;; File .emacs
;; Written by Chris Frisz
;; 
;; Created 17 Dec 2011
;; Last modified Sat Jan  4 13:56:42 2014
;; 
;; Initialization file for Emacs.
;;----------------------------------------------------------------------

;; Backport the user-emacs-directory variable because sometimes I use Emacs 22
(unless (boundp 'user-emacs-directory)
  (defvar user-emacs-directory "~/.emacs.d/" ""))

;; Add the user directory to the load-path variable
(add-to-list 'load-path user-emacs-directory)

;; Add "lisp" for custom-defined elisp functions
(add-to-list 'load-path
  (concat user-emacs-directory
    (convert-standard-filename "lisp/")))

(setq explicit-shell-file-name
  (cond ((eq system-type 'gnu/linux) "/usr/bin/zsh")
	((eq system-type 'darwin) "/usr/local/bin/zsh")
	(t "/bin/bash")))

;; Load custom functions
(load "lisp-load.el")

;;-- Global and miscellaneous settings --;;

;; Marmalade: because I really don't need to make things hard for
;; myself
(require 'package)
(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; Testing for CIDER
;(add-to-list 'load-path "~/projects/personal/cider")

;; Shortcut for goto-line
(global-set-key "\M-g" 'goto-line)

;; I find narrow-to-region useful
(put 'narrow-to-region 'disabled nil)

;; For block comments, I like to have a repeated character at the
;; beginning, end, and often throughout blocks. By default, I use the
;; dash ('-') character. I prefer different ones for certain
;; languages, and so there are hooks for those major modes.
(set 'block-comment-decorator "-")

;; Enable column number mode
(column-number-mode t)

;; And...let's show the time
(display-time)

;; Date format string
(set 'cjfrisz-date-format "%e %b %Y")

;; Set fill-column value explicitly
(set 'fill-column 72)

;; Don't need no menu bar
(menu-bar-mode nil)

;; Default to text mode if nothing else overrides it
(set-default 'major-mode 'text-mode)

;; Turn on auto-fill-mode for text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Move auto-saves and backup files to the auto-save-list directory
;; Modified from the EmacsWiki
(let ((auto-save-directory 
  (concat user-emacs-directory
    (convert-standard-filename "auto-save-list/"))))
  (setq backup-directory-alist
    `((".*" . ,auto-save-directory)))
  (setq auto-save-file-name-transforms
    `((".*" ,auto-save-directory t))))

;; Highlight parentheses in all modes
;; Taken from the EmacsWiki
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; Useful definitions for replacing character sequences with unicode
;; characters, i.e. replace the word "lambda" with the Greek letter.
;; Adapted from "PrettySymbolsForLanguages" page on the Emacs wiki:
;; http://www.emacswiki.org/emacs/PrettySymbolsForLanguages
(defun unicode-symbol (name)
  "Translate a symbolic name for a Unicode character -- e.g.,
     LEFT-ARROW or GREATER-THAN into an actual Unicode character
     code. "
  (decode-char 'ucs (case name
                        ;; arrows
                        ('left-arrow 8592)
                        ('up-arrow 8593)
                        ('right-arrow 8594)
                        ('down-arrow 8595)
                        ;; boxes
                        ('double-vertical-bar #X2551)
                        ;; relational operators
                        ('equal #X003d)
                        ('not-equal #X2260)
                        ('identical #X2261)
                        ('not-identical #X2262)
                        ('less-than #X003c)
                        ('greater-than #X003e)
                        ('less-than-or-equal-to #X2264)
                        ('greater-than-or-equal-to #X2265)
                        ;; logical operators
                        ('logical-and #X2227)
                        ('logical-or #X2228)
                        ('logical-neg #X00AC)
                        ;; misc
                        ('nil #X2205)
                        ('horizontal-ellipsis #X2026)
                        ('double-exclamation #X203C)
                        ('prime #X2032)
                        ('double-prime #X2033)
                        ('for-all #X2200)
                        ('there-exists #X2203)
                        ('element-of #X2208)
                        ;; mathematical operators
                        ('square-root #X221A)
                        ('squared #X00B2)
                        ('cubed #X00B3)
                        ;; letters
                        ('lambda #X03BB)
                        ('alpha #X03B1)
                        ('beta #X03B2)
                        ('gamma #X03B3)
                        ('delta #X03B4))))

(defun substitute-pattern-with-unicode (pattern symbol)
  "Add a font lock hook to replace the matched part of PATTERN
   with the Unicode symbol SYMBOL looked up with UNICODE-SYMBOL."
  (interactive)
  (font-lock-add-keywords
   nil `((,pattern (0 (progn (compose-region (match-beginning 1)
                                             (match-end 1)
                                             ,(unicode-symbol
                                               symbol))
                             nil))))))
  
(defun substitute-patterns-with-unicode (patterns)
  "Call SUBSTITUTE-PATTERN-WITH-UNICODE repeatedly."
  (mapcar #'(lambda (x)
              (substitute-pattern-with-unicode (car x)
                                               (cdr x)))
          patterns))

;; Ensure that there's a newline at the end of a file
(setq require-final-newline t)

(setq evil-toggle-key "M-`")
(require 'evil)
(evil-mode 1)

;;--------------------------------;;
;;-- Language-specific settings --;;
;;--------------------------------;;

;;-- C/C++ --;;

;; Set the block comment beginning-of-line string
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-block-comment-prefix "* ")
 '(erc-nick "cjfrisz")
 '(erc-server "irc.soic.indiana.edu"))

;; I prefer auto-fill-mode for C/C++
(add-hook 'c-mode-common-hook 'auto-fill-mode)


;;-- Lisp (including Emacs Lisp) --;;

;; Indentation rules
;; I really don't know why these aren't defined correctly
(put 'case 'lisp-indent-function 1)
(put 'if 'lisp-indent-function 3)

;; Auto-fill-mode for Emacs Lisp is nice, too
(add-hook 'emacs-lisp-mode-hook 'auto-fill-mode)


;;-- Scheme --;;

;; Use petite as the default Scheme program
(custom-set-variables '(scheme-program-name "petite"))

;; IU Scheme setup
(autoload 'scheme-mode "iuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "iuscheme" "Switch to interactive Scheme buffer." t)
 
;; Use auto-fill-mode for Scheme
(add-hook 'scheme-mode-hook 'auto-fill-mode)

;; Teach Emacs how to properly indent
;; certain Scheme special forms
;; (such as 'pmatch')
(put 'cond 'scheme-indent-function 0)
(put 'for-each 'scheme-indent-function 0)
(put 'pmatch 'scheme-indent-function 1)
(put 'match 'scheme-indent-function 1)
(put 'union-case 'scheme-indent-function 2)
(put 'cases 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 2)
(put 'syntax-case 'scheme-indent-function 2)
(put 'test 'scheme-indent-function 1)
(put 'test-check 'scheme-indent-function 1)
(put 'test-divergence 'scheme-indent-function 1)
(put 'make-engine 'scheme-indent-function 0)
(put 'with-mutex 'scheme-indent-function 1)
(put 'trace-lambda 'scheme-indent-function 1)
(put 'timed-lambda 'scheme-indent-function 1)
(put 'tlambda 'scheme-indent-function 1)
(put 'when 'scheme-indent-function 1)
(put 'unless 'scheme-indent-function 1)
(put 'module 'scheme-indent-function 2)
(put 'values 'scheme-indent-function 0)


;;--Clojure--;;
(when (not (package-installed-p 'clojure-mode))
  (package-install 'clojure-mode))

(require 'clojure-mode)

;; Enable auto-fill mode
(add-hook 'clojure-mode-hook 'auto-fill-mode)
;; Due to syntax differences with other Lisp-like languages, Clojure
;; is better suited to a fill-column value of 80
(add-hook 'clojure-mode-hook (lambda () (set-fill-column 80)))

;; Clojure needs some help with indenting
(put 'match 'clojure-indent-function 1)
(put 'if 'clojure-indent-function 0) ;; Really??

;; CIDER options
(when (not (package-installed-p 'cider))
  (package-install 'cider))
(unless (package-installed-p 'cider-tracing)
  (package-install 'cider-tracing))

(add-hook 'cider-interaction-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(add-hook 'cider-mode-hook 'rainbow-delimiters-mode)
(setq cider-repl-popup-stacktraces t)
(setq cider-repl-display-in-current-window t)
(setq cider-repl-toggle-pretty-printing t)
;(load-library "troncle")

;;--ClojureScript--;;
(when (not (package-installed-p 'clojurescript-mode))
  (package-install 'clojurescript-mode))
