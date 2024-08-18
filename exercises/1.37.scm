;recursive
(define (cont-frac n d k)
  (if (<= k 0)
    0
    (/ (n k) (+ (d k) (cont-frac n d (- k 1))))))

;iterative
(define (cont-frac n d k)
  (define (iterate a result)
    (if (< a 1)
      result
      (iterate a (/ (n a) (+ (d a) result)))))
  (iterate k 0))

;phi
(define (phi k)
  (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) k))
