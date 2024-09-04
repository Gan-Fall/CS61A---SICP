(define (substitute items oldwd newwd)
  (cond ((null? items) '())
        ((list? (car items)) (cons (substitute (car items) oldwd newwd) (substitute (cdr items) oldwd newwd)))
        ((equal? oldwd (car items)) (cons newwd (substitute (cdr items) oldwd newwd)))
        (else (cons (car items) (substitute (cdr items) oldwd newwd))) ))
