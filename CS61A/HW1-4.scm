;(define (ordered? sent)
;  (if (empty? sent) #f (ordered-iter (first sent) (bf sent))))

;(define (ordered-iter sent1 sent2)
;  (cond
;    ((empty? sent2) #t)
;    ((> sent1 (first sent2)) #f)
;    (else (ordered-iter (first sent2) (bf sent2)))))

(define (ordered? sent)
  (cond ((empty? (bf sent)) #t)
	((<= (first sent) (first (bf sent))) (ordered? (bf sent)))
	(else #f)))
