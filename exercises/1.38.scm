;iterative
(define (cont-frac n d k)
  (define (iterate a result)
    (if (< a 1)
      result
      (iterate (- a 1) (/ (n a) (+ (d a) result)))))
  (iterate k 0))

;recursive
(define (cont-frac n d k)
  (if (<= k 0)
    0
    (/ (n k) (+ (d k) (cont-frac n d (- k 1))))))

(define (euler k)
  (+ (cont-frac
    (lambda (i) 1.0)
    (lambda (i) (if (= (remainder (- i 2) 3) 0)
                  (* 2 (+ 1 (quotient (- i 2) 3)))
                  1))
    k) 2))
