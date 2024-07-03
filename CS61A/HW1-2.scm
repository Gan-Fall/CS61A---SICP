;(define (squares sent)
;  (every square sent))

(define (squares sent)
   (if (not (empty? sent)) (sentence (square (first sent)) (squares (bf sent))) '()))
