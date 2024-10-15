(define (equal? a b)
  (cond ((and (null? a) (null? b)) #t)
        ((or (null? a) (null? b)) #f)
        ((and (symbol? a) (symbol? b)) (eq? a b))
        ((or (symbol? a) (symbol? b)) #f)
        ((and (number? a) (number? b)) (= a b))
        ((or (number? a) (number? b)) #f)
        ((equal? (car a) (car b)) (equal? (cdr a) (cdr b)))
        (else #f)))
