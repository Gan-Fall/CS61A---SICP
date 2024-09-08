(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (reverse items)
  (define (helper iteration count iter-items)
    (if (>= iteration count)
      iter-items
      (helper (+ 1 iteration) count (cons (cdr iter-items) (car iter-items))) ))
  (helper 0 (length items) items))
