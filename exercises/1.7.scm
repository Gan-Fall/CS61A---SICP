;(define (sqrt-iter guess x)
;  (if (good-enough? guess x)
;    guess
;    (sqrt-iter (improve guess x) x)))
 
(define (sqrt-iter guess x)
  (if (close-enough? guess (improve guess x))
     guess
     (sqrt-iter (improve guess x) x)
  )
)
  

(define (improve guess x)
  (average guess (/ x guess)))
   
(define (average x y)
  (/ (+ x y) 2))
 
;(define (good-enough? guess x)
;  (< (abs (- (square guess) x)) 0.001))

(define (close-enough? guess next-guess)
  (< (abs (- guess next-guess)) 0.001))
