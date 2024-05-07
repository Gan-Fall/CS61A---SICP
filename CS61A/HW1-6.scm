(define (or-test)
  (or (= 1 1) (or-test)))

(define (and-test)
  (and (= 1 0) (and-test)))
