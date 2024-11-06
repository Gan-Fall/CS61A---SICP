(define (make-from-mag-ang r A)
  (define (dispatch op)
    (cond ((eq? op 'magnitude) r)
          ((eq? op 'angle) A)
          ((eq? op 'real-part)
           (* r (cos A)))
          ((eq? op 'imag-part)
           (* r (sin A)))
          (else
           (error "Unknown op: 
            MAKE-FROM-MAG-ANG" op))))
  dispatch)
