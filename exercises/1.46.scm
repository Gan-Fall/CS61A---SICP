;(define (iterative-improve predicate improve)
;   (lambda (guess)
;    (if (predicate guess)
;      (guess)
;      ((iterative-improve predicate improve) (improve guess)))))

;(define (iterative-improve predicate iter-improve)
;  (lambda (x guess)
;    (if (predicate guess (iter-improve guess ))
;      (guess)
;      ((iterative-improve predicate iter-improve) (iter-improve guess)))))

;(define (iterative-improve predicate improve-guess)
;  (lambda (guess)
;    (if (predicate guess)
;      guess
;      ((iterative-improve predicate improve-guess) (improve guess)))))

;(define (sqrt n)
;  (let ((rethread (iterative-improve good-enough? sqrt-improve))) 
;    ()))

;(define (sqrt-improve guess x)
;  (average guess (/ x guess)))

;(define (average x y)
;  (/ (+ x y) 2))

(define (iterative-improve predicate iter-improve)
  (define (iterate guess)
    (if (predicate guess)
      guess
      (iterate (iter-improve guess))))
  iterate)

;(define (iterative-improve predicate improve)
;   (lambda (guess)
;    (if (predicate guess)
;      (guess)
;      ((iterative-improve predicate improve) (improve guess)))))

(define (sqrt x)
  ((iterative-improve (lambda (guess) (< (abs (- (square guess) x)) 0.001))
		     (lambda (guess) (average guess (/ x guess)))) 1.0))

(define (average x y)
  (/ (+ x y) 2))

(define (fixed-point f first-guess)
  ((iterative-improve (lambda (guess) (< (abs (- guess (f guess))) 0.00001))
		     f) first-guess))
