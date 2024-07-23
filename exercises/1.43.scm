(define (repeated f n) (lambda (x)
   (if (<= n 1)
      (f x)
      ((compose f (repeated f (- n 1))) x))))
