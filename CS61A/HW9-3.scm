;original
(define (bubble-sort! v1)
  (let ((vect-len (vector-length v1)))
    (define (loop n)
      ;(if (= (+ n 1) (- vect-len 1))
      (if (= (+ n 1) vect-len)
        v1
        (let ((current (vector-ref v1 n))
              (next (vector-ref v1 (+ n 1))))
          (if (> current next)
            (begin (vector-set! v1 n next)
                   (vector-set! v1 (+ n 1) current)
                   (loop (+ n 1)))
            (loop (+ n 1)) )) ))))

;doesn't work
(define (bubble-sort! v1)
  (define (loop n)
    (cond ((= (+ n 1) (vector-length v1)) 'done)
          ((> (vector-ref v1 n) (vector-ref v1 (+ n 1)))
              (let ((current (vector-ref v1 n))
                    (next (vector-ref v1 (+ n 1))))
                (begin (vector-set! v1 n next)
                       (vector-set! v1 (+ n 1) current)
                       (loop (+ n 1)))))
          (else (loop (+ n 1))) ))
  (loop 0))

;works???
(define (bubble-sort! v1)
  (define (loop n)
    (cond ((= (+ n 1) (vector-length v1)) 'done)
          ((> (vector-ref v1 n) (vector-ref v1 (+ n 1)))
              (let ((current (vector-ref v1 n))
                    (next (vector-ref v1 (+ n 1))))
                (begin (vector-set! v1 n next)
                       (vector-set! v1 (+ n 1) current))))
          (else (loop (+ n 1))) ))
  (define (iterate)
    (if (equal? (loop 0) 'done)
      'done
      (iterate)))
  (iterate))

;Start at later of the two swapped numbers
(define (bubble-sort! v1)
  (define (loop n)
    (cond ((= (+ n 1) (vector-length v1)) 'done)
          ((> (vector-ref v1 n) (vector-ref v1 (+ n 1)))
              (let ((current (vector-ref v1 n))
                    (next (vector-ref v1 (+ n 1))))
                (begin (vector-set! v1 n next)
                       (vector-set! v1 (+ n 1) current)
                       (loop n))))
          (else (loop (+ n 1))) ))
  (loop 0))

;Start at beginning of array - works
(define (bubble-sort! v1)
  (define (loop n)
    (cond ((= (+ n 1) (vector-length v1)) 'done)
          ((> (vector-ref v1 n) (vector-ref v1 (+ n 1)))
              (let ((current (vector-ref v1 n))
                    (next (vector-ref v1 (+ n 1))))
                (begin (vector-set! v1 n next)
                       (vector-set! v1 (+ n 1) current)
                       (loop 0))))
          (else (loop (+ n 1))) ))
  (loop 0))

;Start at 1 earlier than swapped numbers - works
(define (bubble-sort! v1)
  (define (loop n)
    (cond ((= (+ n 1) (vector-length v1)) 'done)
          ((> (vector-ref v1 n) (vector-ref v1 (+ n 1)))
              (let ((current (vector-ref v1 n))
                    (next (vector-ref v1 (+ n 1))))
                (begin (vector-set! v1 n next)
                       (vector-set! v1 (+ n 1) current)
                       (loop (- n 1)))))
          (else (loop (+ n 1))) ))
  (loop 0))