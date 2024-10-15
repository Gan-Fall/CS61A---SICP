(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (remove x S)) rest)))))

(define (remove element items)
  (if (null? items)
    items
    (if (= element (car items))
      (remove element (cdr items))
      (cons (car items) (remove element (cdr items))))))

;Attempt 2
(define (subsets s)
  (if (null? s)
    (list '())
    (let ((rest (subsets (cdr s))))
      (append rest (map (lambda (x) (cons (car s) x)) rest)))))
