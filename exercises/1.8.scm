;cubert-itr
;(define (cubert-itr guess x)
;  (if (good-enough? guess x)
;         guess
;	 (cubert-itr (improve guess x) x)))

;good enough?
;(define (good-enough? guess x)
;  (< (abs (- guess x)) 0.001))


;improve
;(define (improve guess x)
;  (/ 
;    (+
;       (/ x (square guess))
;       (* 2 guess)
;    )
;   3
;  )
;)

;cubert-itr
(define (cubert-itr guess x)
  (if (good-enough? guess x)
         guess
	 (cubert-itr (improve guess x) x)))

;good enough?
(define (good-enough? guess x)
  (< (abs (- guess x)) 0.0001))


;improve
(define (improve guess x)
  (/  (+ (numerator1 guess x) (numerator2 guess x) ) 3))

(define (numerator1 guess x)
  (/ x (square guess)))

(define (numerator2 guess x)
  (* 2 guess))
