;plural.scm
(define (plural wd)
  (word wd 's))

(define (plural wd)
  (if (equal? (last wd) 'y)
      (word (bl wd) 'ies)
      (word wd 's)))

;fix
(define (vowel? wd)
  (member? wd 'aeiou))

(define (plural wd)
  (cond ((and (equal? (last wd) 'y) (vowel? (last (bl wd)))) (word wd 's))
        ((equal? (last wd) 'y) (word (bl wd) 'ies))
        (else (word wd 's))))
