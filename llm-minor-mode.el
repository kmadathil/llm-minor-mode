(defgroup llm-mode nil
  "Customization group for LLM minor mode."
  :group 'convenience)

(defcustom llm-check-strings '("Certainly!" "Absolutely.")
  "List of strings to check for in the buffer."
  :type '(repeat string)
  :group 'llm-mode)

(defun llm-check-strings ()
  "Search for occurrences of strings specified in `llm-check-strings'."
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search t)
          (counts (make-hash-table :test 'equal)))
      (dolist (str llm-check-strings)
        (goto-char (point-min))
        (let ((count 0))
          (while (search-forward str nil t)
            (setq count (1+ count)))
          (when (> count 0)
            (puthash str count counts))))
      (when (> (hash-table-count counts) 0)
        (with-current-buffer (get-buffer-create "*LLM Check Results*")
          (erase-buffer)
          (insert "LLM Check Results:\n\n")
          (maphash (lambda (str count)
                     (insert (format "Found %d occurrence(s) of \"%s\"\n" count str)))
                   counts)
          (display-buffer (current-buffer)))))))

(define-minor-mode llm-minor-mode
  "Minor mode for checking LLM-specific patterns in text."
  :lighter " LLM"
  :global nil
  (if llm-minor-mode
      (add-hook 'before-save-hook #'llm-check-strings nil t)
    (remove-hook 'before-save-hook #'llm-check-strings t)))

(provide 'llm-minor-mode)
