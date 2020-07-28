;;; sly-annot.el --- cl-annot support for SLY

;; URL: https://github.com/arielnetworks/cl-annot
;; Package-Requires: ((sly "0"))

;;; Commentary:

;;; Code:

(require 'cl)
(require 'sly)

(defvar sly-annotation-face 'highlight)
(font-lock-add-keywords 'lisp-mode `(("\\(?:^\\|[^,]\\)\\(@\\(?:\\sw\\|\\s_\\)+\\)" (1 ,sly-annotation-face))))

(defvar sly-annotation-max-arity 3)

(defun sly-beginning-of-annotation ()
  (interactive)
  (ignore-errors
    (let ((point (point)) found)
      (save-excursion
        (setq found
              (loop repeat sly-annotation-max-arity
                    while 
                    (save-excursion
                      (let ((point (point)))
                        (backward-sexp)
                        (forward-sexp)
                        (<= (count-lines (point) point) 1)))
                    do (backward-sexp)
                    if (eq (char-after) ?\@)
                    return (point))))
      (when found
        (goto-char found)))))

(defun sly-beginning-of-annotation* ()
  (interactive)
  (while (sly-beginning-of-annotation)))

(defadvice sly-region-for-defun-at-point (after sly-region-for-defun-at-point-with-annotations activate)
  (save-excursion
    (goto-char (car ad-return-value))
    (sly-beginning-of-annotation*)
    (setq ad-return-value (list (point) (cadr ad-return-value)))))

(provide 'sly-annot)

;;; sly-annot.el ends here

;;; (require 'sly-annot)
