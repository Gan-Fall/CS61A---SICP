(cadaddr '(1 3 (5 7) 9))
;or
(cadr (caddr '(1 3 (5 7) 9)))

(caar '((7)))

(cadadadadadadr '(1 (2 (3 (4 (5 (6 7)))))))
;or
(cadr (cadr (cadr (cadr (cadr (cadr '(1 (2 (3 (4 (5 (6 7))))))))))))
