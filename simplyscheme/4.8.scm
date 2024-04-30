(define (scientific n e)
  (* n (expt 10 e)))

(define (sci-coefficient n)
  (/ n (expt 10 (appearances 0 n))))

(define (sci-exponent n)
  (appearances 0 n))
