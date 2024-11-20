(define f
  (let ((remember 1))
    (lambda (n) (set! remember (* remember n))
                remember)))
