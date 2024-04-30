(define (query sent)
  (se (se (first (bf sent)) (first sent) (bf (bf (bl sent)))) (word (last sent) `?)))
