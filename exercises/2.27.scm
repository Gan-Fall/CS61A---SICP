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

(define (deep-reverse items)
  (define (helper items result)
    (if (null? items)
      result
      (helper (cdr items) (cons (if (list? (car items))
                                  (deep-reverse (car items))
                                  (car items)) result)) ))
  (helper items '()))

(define (deep-reverse lst)
  (define (iter old new)
    (cond ((null? old) new)
	  ((not (pair? old)) old)
	  (else (iter (cdr old) (cons (deep-reverse (car old)) new)))))
  (iter lst '()))
