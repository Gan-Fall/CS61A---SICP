;(define (switch sent)
;  (if (equal? 'You (first sent))
;       (switch-iter (sentence 'I (bf sent)))
;       (switch-iter sent)))
;
;(define (switch-iter sent)
;  (cond ((empty? sent) sent)
;	((or (equal? 'I (first sent)) (equal? 'me (first sent))) (switch-iter (sentence 'you (bf sent))))
;	((equal? (first sent) 'you) (switch-iter (sentence 'me (bf sent))))
;	(else '(Unknown Error))))

(define (switch-wd wd)
  (cond ((or (equal? wd 'I) (equal? wd 'me))'you)
	((equal? wd 'You) 'I)
	((equal? wd 'you) 'me)
	(else wd)))

(define (switch sent)
  (every switch-wd sent))