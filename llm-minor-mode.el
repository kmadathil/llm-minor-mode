(defun check-for-certainly ()
  "Search for occurrences of 'Certainly' in the buffer."
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (search-forward "Certainly" nil t)
        (setq count (1+ count)))
      (if (> count 0)
          (message "Warning: Found %d occurrence(s) of 'Certainly' in the buffer." count)))))

(define-minor-mode llm-minor-mode
  "Minor mode for checking LLM-specific patterns in text."
  :lighter " LLM"
  :global nil
  (if llm-minor-mode
      (add-hook 'after-save-hook #'check-for-certainly nil t)
    (remove-hook 'after-save-hook #'check-for-certainly t)))

(provide 'llm-minor-mode)
