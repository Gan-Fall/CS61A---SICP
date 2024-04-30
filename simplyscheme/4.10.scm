;(define (tip bill) 
;  (* (ceiling (* (* bill 0.15) 100)) 0.01))

(define (tip bill) 
  (+ (* bill 0.15)
     (- (ceiling (+ bill (* bill 0.15)))
	(+ bill (* bill 0.15)))))
