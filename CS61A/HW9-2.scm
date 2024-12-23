;ver 1 - prints backwards
(define (vector-filter pred v1)
  (define (loop-extract n)
    (cond ((< n 0) '())
          ((pred (vector-ref v1 n)) (cons n (loop-extract (- n 1))))
          (else (loop-extract (- n 1))) ))
  (define (loop-cons pos-list result n)
    (if (null? pos-list)
      result
      (begin (vector-set! result n (vector-ref v1 (car pos-list)))
             (loop-cons (cdr pos-list) result (+ n 1))) ))
  (let* ((pos-list (loop-extract (- (vector-length v1) 1)))
         (new-vect-len (length pos-list)))
    (loop-cons pos-list (make-vector new-vect-len) 0) ))

;ver 2 - preserves vector order
(define (vector-filter pred v1)
  (define (loop-extract n)
    (cond ((< n 0) '())
          ((pred (vector-ref v1 n)) (cons n (loop-extract (- n 1))))
          (else (loop-extract (- n 1))) ))
  (define (loop-cons pos-list result n)
    (if (null? pos-list)
      result
      (begin (vector-set! result n (vector-ref v1 (car pos-list)))
             (loop-cons (cdr pos-list) result (- n 1))) ))
  (let* ((pos-list (loop-extract (- (vector-length v1) 1)))
         (new-vect-len (length pos-list)))
    (loop-cons pos-list (make-vector new-vect-len) (- new-vect-len 1)) ))
