(define (make-interval a b) (cons a b))
(define (upper-bound x) (max (car x) (cdr x)))
(define (lower-bound x) (min (car x) (cdr x)))

;(define (sub-interval x y)
;  (make-interval (- (max (upper-bound x) (upper-bound y)) (min (upper-bound x) (upper-bound y)))
;                 (- (max (lower-bound x) (lower-bound y)) (min (lower-bound x) (lower-bound y))) ))

;(define (sub-interval x y)
;  (make-interval (abs (- (upper-bound x) (upper-bound y)))
;                 (abs (- (lower-bound x) (lower-bound y))) ))

(define (sub-interval x y)
  (make-interval (- (upper-bound x) (upper-bound y))
                 (- (lower-bound x) (lower-bound y)) ))
