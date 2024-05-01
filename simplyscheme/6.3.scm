;(define (sign number)
;  (if (< number 0)
;      'negative
;      (if (= number 0)
;	  'zero
;	  'positive)))

(define (sign number)
  (cond ((< number 0) 'negative)
  ((= number 0) 'zero)
  (else 'positive)))
