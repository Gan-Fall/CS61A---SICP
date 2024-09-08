;My attempt
(define (for-each proc items)
  (if (null? items)
    #t
    (and (proc (car items)) (for-each proc (cdr items))) ))

(define (dummy . l)
  #t)

(define (test) car)

(define (car-or-cdr wd)
  (if (equal? wd 'a)
    car
    cdr))

(define (cxr-function wd)
  (create-cxr (bf (bl wd))))

(define (invoke-cxr cxr . l)
  (let ((cxr-stack (cxr-function cxr)))
  (for-each (lambda (x) (x l)) cxr-stack)))

(define (create-cxr wd)
  (if (empty? wd)
    ()
    (cons (car-or-cdr (first wd)) (create-cxr (bf wd))) ))

;Answer
(define (compose f g)
  (lambda (x) (f (g x)) ))

(define (cxr-function wd)
  (define (helper wd)
    (if (empty? wd)
      (lambda (x) x)
      (compose (if (equal? (first wd) 'a) car cdr)
               (helper (bf wd))) ))
  (helper (bf (bl wd))) )
