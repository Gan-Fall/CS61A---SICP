;(define (ends-e sent)
;  (keep ends-e-wd? sent))
;
;(define (ends-e-wd? wd)
;  (or (equal? (last wd) 'e) (equal? (last wd) 'E)))

(define (ends-e sent)
  (cond ((empty? sent) '())
	((or (equal? (last (first sent)) 'e)(equal? (last (first sent)) 'E)) (se (first sent) (ends-e (bf sent))))
	(else (ends-e (bf sent)))))
