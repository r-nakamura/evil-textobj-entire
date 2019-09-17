;; -*- Emacs-Lisp -*-
;;
;;
;; Copyright (c) 2019, Ryo Nakamura.
;; All rights reserved.
;;
;; $Id: $
;;

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

(require 'evil)

(defgroup evil-textobj-entire nil
  "Text object entire for Evil"
  :group 'evil)

(defcustom evil-textobj-entire-i-key "e"
  "Keys for evil-inner-entire"
  :type 'string
  :group 'evil-textobj-entire)

(defcustom evil-textobj-entire-a-key "e"
  "Keys for evil-outer-entire"
  :type 'string
  :group 'evil-textobj-entire)

(evil-define-text-object evil-outer-entire (count &optional beg end type)
  "Select an entire buffer excluding leading and trailing empty lines."
  (unless (evil-textobj-entire--string-match "\\(.\\|\n\\)")
    (error ""))
  (evil-range (point-min) (point-max)))

(evil-define-text-object evil-inner-entire (count &optional beg end type)
  "Select an entire buffer."
  (if (evil-textobj-entire--string-match "\\`\n*\\'")
      (error ""))
  (let ((start (save-excursion
                 (goto-char (point-min))
                 (- (re-search-forward "^.") 1)))
        (end (save-excursion
               (goto-char (point-max))
               (re-search-backward "^.")
               (goto-char (line-end-position)))))
    (evil-range start end)))

(defun evil-textobj-entire--string-match (regexp)
  "Return ``string-match'' with REGEXP and strings in the current buffer."
  (string-match regexp (buffer-substring (point-min) (point-max))))

(define-key evil-outer-text-objects-map evil-textobj-entire-a-key 'evil-outer-entire)
(define-key evil-inner-text-objects-map evil-textobj-entire-i-key 'evil-inner-entire)

(provide 'evil-textobj-entire)
