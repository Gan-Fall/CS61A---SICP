(define (c-to-f temperature)
  (+ (*(/ 9 5) temperature) 32))

(define (f-to-c temperature)
  (* (/ 5 9) (- temperature 32)))
