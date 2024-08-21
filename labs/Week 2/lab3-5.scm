((t 1+) 0)
;3

((t (t 1+)) 0)
;9

(((t t) 1+) 0)
;(3^3)^3=19683
;L was actually 27, should have worked it out with the substitution model

(define (t f)
  (lambda (x) (f (f (f x)))) )

(define (1+ x)
  (+ x 1))
