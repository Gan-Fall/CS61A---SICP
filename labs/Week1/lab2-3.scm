(define (two-largest x y z)
  (if (or (> x y) (> x z))
    (if (> y z)
      (se x y)
      (se x z))
    (se y z)))

(define (sum-squares x y z)
  (+ (square (first (two-largest x y z))) (square (last (two-largest x y z)))))
