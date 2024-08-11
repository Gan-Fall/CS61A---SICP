(define (every procedure sent)
  (if (empty? sent)
    ()
    (sentence (procedure (first sent)) (every procedure (bf sent)))))
