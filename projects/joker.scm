; 1.
;Algorithm assumes A) cards are sorted with aces at the end B) No two of the same card in the hand
(define (base-total hand)
  (define (iter sent result)
    (if (empty? sent)
      result
      (iter (bf sent) (+ result (card-value (first sent))))))
  (iter hand 0))

(define (card-value wd)
  (cond ((or (equal? 'k (first wd)) (equal? 'K (first wd))) 10)
        ((or (equal? 'q (first wd)) (equal? 'Q (first wd))) 10)
        ((or (equal? 'j (first wd)) (equal? 'J (first wd))) 10)
        ((equal? 10 (word (first wd) (first (bf wd)))) 10)
        (else (first wd)) ))

(define (is-ace? card)
  (or (equal? (first card) 'a)
      (equal? (first card) 'A)))

(define (is-joker? card)
  (or (or (equal? card 'joker)
          (equal? card 'JOKER))
      (equal? card 'Joker)))

(define (count-aces hand)
  (define (iter sent result)
    (if (empty? sent)
      result
      (iter (bf sent) (if (is-ace? (first sent))
                        (+ 1 result)
                        result)) ))
  (iter hand 0))

(define (count-jokers hand)
  (define (iter sent result)
    (if (empty? sent)
      result
      (iter (bf sent) (if (is-joker? (first sent))
                        (+ 1 result)
                        result)) ))
  (iter hand 0))

(define (remove-special hand)
  (if (empty? hand)
    '()
    (if (or (is-joker? (first hand)) (is-ace? (first hand)))
      (remove-special (bf hand))
      (sentence (first hand) (remove-special (bf hand)))) ))

(define (best-total hand)
  (define (iter result aces jokers)
    (cond ((> aces 0) (iter (add-aces aces jokers result) 0 jokers))
          ((> jokers 0) (iter (add-jokers jokers result) 0 0))
          (else result) ))
  (iter (base-total (remove-special hand)) (count-aces hand) (count-jokers hand)) )

(define (calculate-aces aces target)
  (if (> target (+ 10 (- aces 1)))
         (+ 11 (- aces 1))
         aces))

(define (add-aces aces jokers score)
  (cond ((> (+ score aces jokers) 21) (+ score aces))
        ((= jokers 2) (+ score (calculate-aces aces (- 19 score))))
        ((= jokers 1) (+ score (calculate-aces aces (- 20 score))))
        (else (+ score (calculate-aces aces (- 21 score)))) ))

(define (add-jokers jokers results)
  (cond ((> (+ results jokers) 21) (+ results jokers))
        ((> 21 (+ results (* jokers 11))) (+ results (* jokers 11)))
        (else 21) ))

;(define (count sent)
; (if (empty? sent)
;   0
;   (+ 1 (count (bf sent))) ))

;define (sort-cards sent)
; (sentence (keep (lambda (x) (not (or (equal? 'a (first x)) (equal? 'joker x)))) sent)
;           (keep (lambda (x) (equal? 'a (first x))) sent)
;           (keep (lambda (x) (equal? 'joker x)) sent) ))

;(define (card-value wd total last-card?)
;  (cond ((equal? 'joker wd) (cond ((> total 19) 1)
;                                  (last-card? (if (> total 9) (- 21 total) 11))
;                                  ((< total 10) 11)
;                                  (else (- 20 total))) )
;        ((or (equal? 'a (first wd)) (equal? 'A (first wd))) (if (or (> total 10) (not last-card?)) 1 11))
;        ((or (equal? 'k (first wd)) (equal? 'K (first wd))) 10)
;        ((or (equal? 'q (first wd)) (equal? 'Q (first wd))) 10)
;        ((or (equal? 'j (first wd)) (equal? 'J (first wd))) 10)
;        ((equal? 10 (word (first wd) (first (bf wd)))) 10)
;        ((empty? wd) 0)
;        (else (first wd)) ))

;define (card-value wd total last-card?)
; (cond ((equal? 'joker wd) (cond ((and last-card? (> total 9)) (- 21 total))
;                                 ((and last-card? (< total 10)) 11)
;                                 ((and (not last-card?) (> total 9)) (- 21 total))
;                                 ((and (not last-card?) (< total 10)) 11)) )
;       ((or (equal? 'a (first wd)) (equal? 'A (first wd))) (if (or (> total 10) (not last-card?)) 1 11))
;       ((or (equal? 'k (first wd)) (equal? 'K (first wd))) 10)
;       ((or (equal? 'q (first wd)) (equal? 'Q (first wd))) 10)
;       ((or (equal? 'j (first wd)) (equal? 'J (first wd))) 10)
;       ((equal? 10 (word (first wd) (first (bf wd)))) 10)
;       ((empty? wd) 0)
;       (else (first wd)) ))

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
