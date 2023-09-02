(require 'setup)
(require 'general)

(setup-define :ghook
  (lambda (function)
    `(general-add-hook ',(setup-get 'hook) ,function))
  :documentation "Add FUNCTION to current hook."
  :ensure '(func)
  :repeatable t)

(setup-define :ghook-into
  (lambda (mode)
    `(general-add-hook ',(let ((name (symbol-name mode)))
                   (if (string-match-p "-hook\\'" name)
                       mode
                     (intern (concat name "-hook"))))
               #',(setup-get 'func)))
  :documentation "Add current function to HOOK."
  :repeatable t)

(setup-define :with-state
  (lambda (states &rest body)
    (let (bodies)
      (dolist (state (if (listp states) states (list states)))
        (push (setup-bind body (state state))
              bodies))
      (macroexp-progn (nreverse bodies))))
  :documentation "Change the MAP that BODY will bind to.
If MAP is a list, apply BODY to all elements of MAP."
  :debug '([&or ([&rest sexp]) sexp] setup)
  :indent 1)

(setup-define :general
  (lambda (key command)
    `(general-def ,(setup-get 'state) ,(setup-get 'map) ,key ,command))
  :documentation "Bind KEY to COMMAND in current map."
  :after-loaded t
  :debug '(form sexp)
  :repeatable t)

(provide 'setup-general)
