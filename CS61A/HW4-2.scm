;version 1
(define (substitute items oldwd newwd)
  (cond ((null? items) '())
        ((list? (car items)) (cons (substitute (car items) oldwd newwd) (substitute (cdr items) oldwd newwd)))
        ((equal? oldwd (car items)) (cons newwd (substitute (cdr items) oldwd newwd)))
        (else (cons (car items) (substitute (cdr items) oldwd newwd))) ))

;version 2
(define (substitute items oldwd newwd)
  (cond ((null? items) items)
        ((list? (car items)) (map (lambda (wd) (if (equal? wd oldwd) newwd wd) (car items))))
        ((equal? oldwd (car items)) (cons newwd (substitute (cdr items) oldwd newwd)))
        (else (cons (car items) (substitute (cdr items) oldwd newwd))) ))

;version 3
(define (substitute items oldwd newwd)
  (define (match-and-replace element)
    (cond ((list? element) (map match-and-replace element))
          ((equal? element oldwd) newwd)
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
