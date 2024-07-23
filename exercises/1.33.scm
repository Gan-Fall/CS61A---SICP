;(define (prime? n)
;   (define (prime?-iter i) (cond ((= n i) #t)
;      ((= 0 (remainder n i)) #f)
;      (else (prime?-iter (+ 1 i)))))
;   (if (< n 2) #f (prime?-iter 2)))

(define (prime? n)
   (define (prime?-iter i rootn)
      (cond ((= n i) #t)
	    ((= 0 (remainder n i)) #f)
	    (else (prime?-iter (+ 1 i) rootn))))
   (if (< n 2) #f (prime?-iter 2 (ceiling (sqrt n)))))

(define (filtered-accumulate predicate combiner null-value term a next b)
   (if (> a b) null-value
     (if (predicate a)
       (combiner (term a)
       (filtered-accumulate predicate combiner null-value term (next a) next b))
       (filtered-accumulate predicate combiner null-value term (next a) next b))))
