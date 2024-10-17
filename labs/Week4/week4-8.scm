(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))

(define (reverse items)
  (define (helper iteration)
    (if (<= iteration 0)
      ()
      (cons (list-ref items (- iteration 1)) (helper (- iteration 1))) ))
  (helper (length items)))

;I'm dumb, here is a much better solution
(define (reverse lst)
  (define (iter old new)
    (if (null? old)
	new
	(iter (cdr old) (cons (car old) new))))
  (iter lst nil))
