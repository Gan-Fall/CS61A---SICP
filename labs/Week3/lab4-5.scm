(define (type-check f pred? value)
  (if (pred? value)
    (f value)
    #f))

(define (make-safe f pred?)
  (lambda (value) (type-check f pred? value)))

(define safe-sqrt (make-safe sqrt number?))
