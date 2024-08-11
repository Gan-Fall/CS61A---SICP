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

(define (fact n)
  (if (= n 0)
    1
    (* n (fact (- n 1)))))

;I think the combinator let doesn't need a body or the body should be the structure
;need to keep dissasembling let structure
;((lambda ()
;  (let ((combinator (lambda (n)
;		      (let ((f-body (lambda ()
;				      (if (= n 0)
;					1
;					(* n (combinator (- n 1))))))) (0)))))
;    (combinator 0))))

((lambda (f) (f f)) (lambda (f) (f f)))
((lambda (f) (lambda (x) (f (x x)))) (lambda (f) (lambda (x) (f (x x))))

;Y Combinator
;(lambda () 
;  (let ((f (lambda (x) (x x))))
;    (f f)))

;((lambda (n) 
;  (let* ((f (lambda (x) (if (= x 1) 1 (* x (g (- x 1))))))
;	(g (lambda (x) (if (= x 1) 1 (* x (f (- x 1)))))))
;    (f n))) 1)

;Y Combinator no let
;((lambda (x) (x x)) (lambda (x) (x x)))
;(lambda (n) (((lambda (x) (if (= n 0) 1 (* n (x x (- n 1))))) (lambda (x)(if (= n 0) 1 (* n (x x (- n 1))))))))
;((lambda (n) (((lambda (x y) (if (= y 0) 1 (* y (x x (- y 1))))) (lambda (x y)(if (= y 0) 1 (* y (x x (- y 1))))) n))) 3)
;(lambda (n) (((lambda (x y) (if (= y 0) 1 (* y (x x (- y 1))))) (lambda (x y)(if (= y 0) 1 (* y (x x (- y 1))))) n)))

;Giving up looking up answer
;Y Comb
;(lambda (f) (lambda (n) (f f n)))
;(((lambda (f) (lambda (n) (f f n))
;  (lambda (fun x) 
;    (if (= x 0)
;      1
;      (* x (func (- x 1))))))) 5)
(  (  (lambda (f) (lambda (n) (f f n)))
      (lambda (fun x)
        (if (= x 0)
            1
            (* x (fun fun (- x 1)))))  )
   5)
