; 1.
;Algorithm assumes A) cards are sorted with aces at the end B) No two of the same card in the hand
(define (best-total hand)
  (define (iter sent result)
    (if (empty? sent)
      result
      (iter (bf sent) (+ result (card-value (first sent) result (= 1 (count sent))))) ))
  (iter (sort-cards hand) 0))

(define (card-value wd total last-card?)
  (cond ((or (equal? 'a (first wd)) (equal? 'A (first wd))) (if (or (> total 10) (not last-card?)) 1 11))
        ((or (equal? 'k (first wd)) (equal? 'K (first wd))) 10)
        ((or (equal? 'q (first wd)) (equal? 'Q (first wd))) 10)
        ((or (equal? 'j (first wd)) (equal? 'J (first wd))) 10)
        ((equal? 10 (word (first wd) (first (bf wd)))) 10)
        (else (first wd)) ))

(define (count sent)
  (if (empty? sent)
    0
    (+ 1 (count (bf sent))) ))

(define (sort-cards sent)
  (sentence (keep (lambda (x) (not (equal? 'a (first x)))) sent)
            (keep (lambda (x) (equal? 'a (first x))) sent) ))

;2.
(define (stop-at-17 hand card)
  (if (< 16 (best-total hand))
    #f
    #t))

;3.
(define (play-n strategy n)
  (if (> n 0)
    (+ (twenty-one strategy) (play-n strategy (- n 1)))
    0))

;4.
(define (dealer-sensitive hand card)
  (cond ((and (> (card-value card 0 #t) 6) (< (best-total hand) 17)) #t)
        ((and (< (card-value card 0 #t) 7) (< (best-total hand) 12)) #t)
        (else #f) ))

;5.
(define (stop-at n)
  (lambda (hand card) (if (>= (best-total hand) n) #f #t)))

;6.
(define (has-heart? hand)
  (not
    (empty?
      (keep (lambda (wd) (or (equal? 'h (last wd)) (equal? 'H (last wd))))
            hand) )))

(define (valentine hand card)
  (if (has-heart? hand)
    ((stop-at 19) hand card)
    ((stop-at 17) hand card) ))

;7
(define (has-suit? suit hand)
  (not
    (empty?
      (keep (lambda (wd) (equal? suit (last wd)))
            hand) )))

(define (suit-strategy suit fallback-strategy strategy)
  (lambda (hand card)
    (if (has-suit? suit hand)
      (strategy hand card)
      (fallback-strategy hand card))) )

(define (valentine hand card)
  ((suit-strategy 'H (stop-at 17) (stop-at 19)) hand card))

;8
(define (majority strat1 strat2 strat3)
  (lambda (hand card)
      (cond ((strat1 hand card) (or (strat2 hand card) (strat3 hand card)))
            ((strat2 hand card) (strat3 hand card))
            (else #f)) ))

;9
(define (reckless strategy)
  (lambda (hand card)
    (if (= (best-total hand) 21)
      #f
      (strategy (bl hand) card))) )
