(define (+rat a b)
   (make-rational (+ (numerator a) (numerator b))
                  (+ (denominator a) (denominator b))))
