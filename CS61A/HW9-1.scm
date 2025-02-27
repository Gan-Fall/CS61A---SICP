(define (vector-append v1 v2)
  (define (loop i1 i2 n result)
    (cond ((not (< i2 0)) (begin (vector-set! result n (vector-ref v2 i2))
                                 (loop i1 (- i2 1) (- n 1) result)))
          ((not (< i1 0)) (begin (vector-set! result n (vector-ref v1 i1))
                                 (loop (- i1 1) i2 (- n 1) result)))
          (else result)))
  (define v1-len (vector-length v1))
  (define v2-len (vector-length v2))
  (define total-len (+ v1-len v2-len))
  (loop (- v1-len 1)
        (- v2-len 1)
        (- total-len 1)
        (make-vector total-len)))
