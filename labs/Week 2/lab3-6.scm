(define (1+ x)
  (+ x 1))

(define (t f)
  (lambda (x) (f (f (f x)))) )

(define (s x)
  (+ 1 x))

((t s) 0)
;3

((t (t 1+)) 0)
;9

(((t t) 1+) 0)
;9
;L was 27, again
