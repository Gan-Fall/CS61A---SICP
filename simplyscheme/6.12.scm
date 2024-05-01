(define (vowel? char)
  (member? char 'aeiou))

(define (plural wd)
  (cond ((and (equal? (last wd) 'y) (vowel? (last (bl wd)))) (word wd 's))
	((equal? (last wd) 'y) (word (bl wd) 'ies))
	((equal? (last wd) 'x) (word wd 'es))
	(else (word wd 's))))
