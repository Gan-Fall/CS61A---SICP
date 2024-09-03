(define (last-pair x)
  (if (and (empty? (cdr x)) (car x))
    (car x)
    (last-pair (cdr x)) ))
