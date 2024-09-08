(define (+rat a b)
   (make-rational (+ (numerator a) (numerator b))
                  (+ (denominator a) (denominator b))))

;correct version
(define (+rat a b)
  (make-rational (+ (* (numerator a) (denominator b))
		    (* (denominator a) (numerator b)))
		 (* (denominator a) (denominator b))))
