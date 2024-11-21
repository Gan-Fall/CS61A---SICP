(define (make-adder n) (lambda (x) (+ x n)))

(make-adder 3)

((make-adder 3) 5)

(define (f x) (make-adder 3))

(f 5)

(define g (make-adder 3))

(g 5)

(define (make-funny-adder n)
  (lambda (x)
    (if (equal? x 'new)
      (set! n (+ n 1))
      (+ x n))))

(define h (make-funny-adder 3))

(define j (make-funny-adder 7))

(h 5)

(h 5)

(h 'new)

(h 5)

(j 5)

(let ((a 3))
  (+ 5 a)) 

(let ((a 3))
  (lambda (x) (+ x a))) 

((let ((a 3))
  (lambda (x) (+ x a)))
 5) 

((lambda (x)
   (let ((a 3))
     (+ x a)))
 5) 

(define k
  (let ((a 3))
    (lambda (x) (+ x a)))) 

(k 5) 

(define m
  (lambda (x)
    (let ((a 3))
      (+ x a)))) 

(m 5) 

(define p
  (let ((a 3))
    (lambda (x)
      (if (equal? x 'new)
        (set! a (+ a 1))
        (+ x a))))) 

(p 5) 

(p 5) 

(p 'new) 

(p 5) 

(define r
  (lambda (x)
    (let ((a 3))
      (if (equal? x 'new)
        (set! a (+ a 1))
        (+ x a)))))

(r 5)

(r 5) 

(r 'new) 

(r 5) 

(define s
  (let ((a 3))
    (lambda (msg)
      (cond ((equal? msg 'new)
             (lambda ()
               (set! a (+ a 1))))
            ((equal? msg 'add)
             (lambda (x) (+ x a)))
            (else (error "huh?")))))) 

(s 'add) 

(s 'add 5) 

((s 'add) 5) 

(s 'new) 

((s 'add) 5) 

((s 'new)) 

((s 'add) 5) 

(define (ask obj msg . args)
  (apply (obj msg) args))

(ask s 'add 5) 

(ask s 'new) 

(ask s 'add 5) 

(define x 5) 

(let ((x 10)
      (f (lambda (y) (+ x y))))
  (f 7)) 

(define x 5) 
