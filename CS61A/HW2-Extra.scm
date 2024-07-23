;((lambda (a b)
;   ((lambda (square)
;      (+ (square a) (square b)))
;   (lambda (x) (* x x))))
;3 4)

;((lambda (fact n) 
;   (fact n)) (lambda () 
;      (if (= n 0) 1 (* n (fact (- n 1))))) 5)

;(let* ((fact (lambda (n) (if (= n 0) 1 (* n (loopback (- n 1)))))) 
;       (loopback (lambda (n) (fact n)))) ())


