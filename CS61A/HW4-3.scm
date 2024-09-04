;substitute 2
(define (first-instance item items)
  (define (iter l current-index)
    (cond ((empty? l) #f)
          ((equal? (car l) item) current-index)
          (else (iter (cdr l) (+ 1 current-index))) ))
  (iter items 0))

(define (substitute2 items oldwds newwds)
  (define (match-and-replace element)
    (cond ((list? element) (map match-and-replace element))
          ((member? element oldwds) (list-ref newwds (first-instance element oldwds)))
          (else element) ))
  (map match-and-replace items) )

;list operations
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))

;recursive
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

;iterative
(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) 
                     (+ 1 count))))
  (length-iter items 0))

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) 
            (append (cdr list1) 
                    list2))))

(define (map proc items)
  (if (null? items)
      items
      (cons (proc (car items))
            (map proc (cdr items)))))
