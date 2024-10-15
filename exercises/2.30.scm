(define (treemap proc tree)
  (cond ((null? tree) '())
	((not (pair? tree)) (proc tree))
	(else (cons (treemap proc (car tree))
	      (treemap proc (cdr tree))))))

;With TREEMAP
(define (square-tree tree)
  (treemap square tree))

;Without TREEMAP
(define (square-tree tree)
  (cond ((null? tree) '())
	((not (pair? tree)) (square tree))
	(else (cons (square-tree (car tree))
		    (square-tree (cdr tree)))) ))

;With MAP
(define (square-tree tree)
  (if (number? tree)
    (square tree)
    (map square-tree tree)))
