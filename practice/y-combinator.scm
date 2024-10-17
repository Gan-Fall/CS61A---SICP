;MAP
((lambda (f n)
   ((lambda (map) (map map f n))
    (lambda (map f n)
      (if (null? n)
        '()
        (cons (f (car n)) (map map f (cdr n))) )) ))
 first
 '(the rain in spain))

;FOREACH
((lambda (f items)
   ((lambda (for-each) (for-each for-each f items))
    (lambda (for-each f items)
      (if (null? items)
        #t
        (and (f (car items)) (for-each for-each f (cdr items))) ))))
   (lambda (x) (newline) (display x))
   (list 57 321 88))
