;Recursive
(define (reverse items)
  (if (null? items)
    '()
    (append (reverse (cdr items)) (cons (car items) '()))))

;Iterative
(define (reverse items)
  (define (helper items iter-items)
    (if (null? items)
      iter-items
      (helper (cdr items) (cons (car items) iter-items))) )
  (helper items '()))
