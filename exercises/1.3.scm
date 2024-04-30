(define (max_two a b c)
  (+ 
     (square (max a b c)) 
     (square (- (+ a b c)
		(max a b c)
		(min a b c))
     )
  )
)
