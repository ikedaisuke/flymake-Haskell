;; add this snippet to haskell-mode-hook
(defun haskell-flymake-init ()
  "Overrided the haskell-flymake-init."
  (let* ((temp-file 
	  (flymake-init-create-temp-buffer-copy
	   'flymake-create-temp-inplace))
	 (local-file 
	  (file-relative-name 
	   temp-file (file-name-directory
		      buffer-file-name))))
    (list (expand-file-name
	   "~/bin/flycheck_haskell.pl") ; where helper command is
	  (list local-file))))

(if (and (not (null buffer-file-name)) 
	 (file-exists-p buffer-file-name))
    (progn 
      (flyspell-prog-mode)
      (flymake-mode t)))
