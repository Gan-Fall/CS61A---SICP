(define (type-check f pred? value)
  (if (pred? value)
    (f value)
    #f))
