(define (even? n)
  (= (remainder n 2) 0))

;(define (fast-expt b n a)
;  (cond ((= n 0) a)
;       ((even? n) (fast-expt (* b b) (/ n 2) a))
;       (else (fast-expt b (- n 1) (* b a)))))

;(define (fast-expt b n)
;  (lambda (a) (cond ((= n 0) a)
;       ((even? n) (fast-expt (* b b) (/ n 2) a))
;       (else (fast-expt b (- n 1) (* b a))))) 1.0)

(define (fast-expt b n)
  (define (iter b n a)
    (cond ((= n 0) a)
          ((even? n) (iter (* b b) (/ n 2) a))
          (else (iter b (- n 1) (* b a)))))
  (iter b n 1.0))
