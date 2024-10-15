(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

;; Scheme calculator -- evaluate simple expressions

; The read-eval-print loop:

(define (calc)
  (display "calc: ")
  (flush)
  (print (calc-eval (read)))
  (calc))

; Evaluate an expression:

(define (calc-eval exp)
  (cond ((number? exp) exp)
    ((symbol? exp) exp)
	((list? exp) (calc-apply (car exp) (map calc-eval (cdr exp))))
	(else (error "Calc: bad expression:" exp))))

; Apply a function to arguments:

(define (calc-apply fn args)
  (cond ((equal? fn 'first) (if (null? args)
                              (error "Calc: no args to first")
                              (first (car args))))
    ((equal? fn 'butfirst) (if (null? args)
                              (error "Calc: no args to butfirst")
                              (butfirst (car args))))
    ((equal? fn 'last) (if (null? args)
                              (error "Calc: no args to last")
                              (last (car args))))
    ((equal? fn 'butlast) (if (null? args)
                              (error "Calc: no args to butlast")
                              (butlast (car args))))
    ((equal? fn 'word) (cond ((null? args) (error "Calc: no args to butlast"))
                              ((= (length args) 1) (car args))
                              (else (word (car args) (calc-apply fn (cdr args))))))
    ((eq? fn '+) (accumulate + 0 args))
	((eq? fn '-) (cond ((null? args) (error "Calc: no args to -"))
			   ((= (length args) 1) (- (car args)))
			   (else (- (car args) (accumulate + 0 (cdr args))))))
	((eq? fn '*) (accumulate * 1 args))
	((eq? fn '/) (cond ((null? args) (error "Calc: no args to /"))
			   ((= (length args) 1) (/ (car args)))
			   (else (/ (car args) (accumulate * 1 (cdr args))))))
	(else (error "Calc: bad operator:" fn))))
