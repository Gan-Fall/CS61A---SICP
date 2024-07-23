(define (relative-prime-products n)
   (define (relative-predicate i) (relative-prime? i n))
   (filtered-accumulate relative-predicate * 1 identity 1 inc n))

(define (relative-prime? n i) (= (gcd n i) 1))
