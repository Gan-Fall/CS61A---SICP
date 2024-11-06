; ver 1
(define (raise-generic object)
  (let ((type (type-tag object)))
    (cond ((equal? type 'integer) ((get-coercion 'integer 'rational) object))
          ((equal? type 'rational) ((get-coercion 'rational 'real) object))
          ((equal? type 'real) ((get-coercion 'real 'complex) object))
          ((equal? type 'complex) (error "CAN'T RAISE TYPE: " type))
          (else (error "NO COERCION FOUND FOR TYPE: " type)) )))

;ver 2
;inside scheme-number/integer package
(define (integer->rational n)
  (make-rat n 1))
(put 'raise '(integer) integer->rational)

;inside rational package
(define (rational->real n)
  (make-real (/ (numer n) (denom n))))
(put 'raise '(rational) rational->real)

;inside real package
(define (real->complex n)
  (make-from-real-imag n 0))
(put 'raise '(real) real->complex)

;global generic raise
(define (raise-generic object)
  (apply-generic 'raise object))
