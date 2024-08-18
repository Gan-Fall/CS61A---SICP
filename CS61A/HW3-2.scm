(define (factor? x y)
  (= (remainder y x) 0))

(define (get-factors n)
  (define (helper i sent)
    (cond ((> i n) sent)
          ((factor? i n) (helper (+ i 1) (se sent i)))
          (else (helper (+ i 1) sent))))
  (helper 1 '()))

(define (sum-of-factors n)
  (define (helper i sent)
    (if (empty? sent)
      i
      (helper (+ i (first sent)) (bf sent))))
  (helper 0 (bl (get-factors n))))

(define (next-perf n)
  (define (helper i)
    (if (= (sum-of-factors i) i)
      i
      (helper (+ i 1))))
  (helper (+ n 1)))
