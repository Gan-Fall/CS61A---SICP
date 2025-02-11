(define ones (cons-stream 1 ones))

(define integers 
  (cons-stream 1 (add-streams ones integers)))

(define (partial-sums s)
  (define result
    (cons-stream (stream-car s)
                 (add-streams (stream-cdr s)
                              result)))
  result)
