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

(define (iterative-improve predicate improve)
  (lambda (guess)
    (lambda (y)
      ())))
