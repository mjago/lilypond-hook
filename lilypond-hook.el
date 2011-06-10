;;; lilypond-hook.el --- Automatically display and play lilypond Score
;;; on save action (Currently tested on Mac OSX only)

;; Copyright (C) 2011 Martyn Jago

;; Author: Martyn Jago 
;; Keywords: LilyPond, Score, , Engraving, Music
;; URL: http://github.com/mjago/lilypond-hook.el 

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; 
;; This package provides an Emacs post-save hook to automate the generation
;; and display of Music Score performed in LilyPond (pdf) and also plays the
;; Score in question via Midi player. These automated actions take place on
;; Saving any document with the extension ".ly"

;;; Customizable Options:
;;
;; Below are customizable option list:

;;; Installation:
;;
;; Put lilypond-hook.el in your load-path.
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'lilypond-hook)
;;

;;; Location of LilyPond must be set...

(setq ly-app-path  "/Applications/lilypond.app/Contents/Resources/bin/lilypond")

(defun mj-execute-lilypond ()
  (let ((ly-temp-file (buffer-file-name))
        (ly-eps nil))
    (message "Compiling LilyPond...")
    (save-excursion
      (switch-to-buffer-other-window "*lilypond*")
        (set-buffer "*lilypond*")
        (erase-buffer)
        (call-process
         ly-app-path nil
         "*lilypond*"
         t
         (if ly-eps
             "-dbackend=eps"
           "")
         ly-temp-file)
        (goto-char (point-min))
        (if (not (search-forward "error:" nil t))
            (progn
              (shell-command
               (concat "open "
                       (file-name-nondirectory
                        (file-name-sans-extension
                         ly-temp-file))
                       ".pdf")) 
              (shell-command
               (concat "open "
                       (file-name-nondirectory
                        (file-name-sans-extension
                         ly-temp-file))
                       ".midi")))
          (message "Error in Compilation"))
        (switch-to-buffer-other-window
         (file-name-nondirectory ly-temp-file)))))
    
(defun lilypond-hook ()
  (interactive)  
  (let ((ly-temp-file (buffer-file-name)))
    (when (string-match "ly" (file-name-nondirectory
                              (file-name-extension 
                               ly-temp-file)))
        (mj-execute-lilypond))))
 
(add-hook 'after-save-hook 'lilypond-hook)

(provide 'lilypond-hook)
          
;;; lilypond-hook.el ends here

