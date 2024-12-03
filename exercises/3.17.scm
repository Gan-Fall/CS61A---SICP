(define (count-pairs x)
  (let ((visited '()))
    (define (helper x)
      (if (or (not (pair? x))
            (memq x visited))
      0
      (begin (set! visited (cons x visited))
             (+ (helper (car x))
                (helper (cdr x))
                1)) ))
    (helper x)))
