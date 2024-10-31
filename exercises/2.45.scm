;Ver 1 - I know helper is only stored once but I somehow feel this isn't elegant
(define (split split-direction split-alignment)
  (lambda (painter n)
    (define (helper painter n)
      (if (= n 0)
        painter
        (let ((resultant (helper painter (- n 1))))
          (split-direction painter
                           (split-alignment resultant
                                            resultant))) ))
    (helper painter n) ))

;Ver 2 - Block helper
(define (split split-direction split-alignment)
  (define (helper painter n)
    (if (= n 0)
      painter
      (let ((resultant (helper painter (- n 1))))
        (split-direction painter
                         (split-alignment resultant
                                          resultant))) ))
  (lambda (painter n) (helper painter n)) )

;Ver 3 - Y Combinator
(define (split split-direction split-alignment)
  (lambda (painter n)
    ((lambda (helper) (helper helper painter n))
     (lambda (helper painter n) (if (= n 0)
       painter
       (let ((resultant (helper helper painter (- n 1))))
         (split-direction painter
                          (split-alignment resultant
                                           resultant))))) ) ))
