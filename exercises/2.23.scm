(define (for-each proc items)
  (if (null? items)
    #t
    (and (proc (car items)) (for-each proc (cdr items))) ))
