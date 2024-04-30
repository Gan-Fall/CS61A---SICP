(define (f1 a1 a2)
   (se (bf a1) (bl a2)))

(define (f2 a1 a2)
   (se (bf a1) (bl a2) (word (first a1) (last a2))))

(define (f4 a1 a2)
   (word (first (bf a1)) (first (bf a2))))
