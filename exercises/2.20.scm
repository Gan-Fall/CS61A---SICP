(define (same-parity . l)
  (define (iter x parity)
    (cond ((null? x) '())
          ((and parity (is-even? (car x))) (cons (car x) (iter (cdr x) parity)))
          ((and (not parity) (is-odd? (car x))) (cons (car x) (iter (cdr x) parity)))
          (else (iter (cdr x) parity)) ))
  (iter l (is-even? (car l))) )

(define (is-even? x)
  (if (= x 0)
    #t
    (= (remainder x 2) 0) ))

(define (is-odd? x)
  (if (= x 0)
    #f
    (> (remainder x 2) 0) ))
