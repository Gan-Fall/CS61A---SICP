;given
(define ordered-deck '(AH 2H 3H 4H 5H 6H 7H 8H 9H 10H JH QH KH AS 2S 3S 4S 5S 6S 7S 8S 9S 10S JS QS KS AD 2D 3D 4D 5D 6D 7D 8D 9D 10D JD QD KD AC 2C 3C 4C 5C 6C 7C 8C 9C 10C JC QC KC))
(define (shuffle deck)
  (if (null? deck)
    '()
    (let ((card (nth (random (length deck)) deck)))
      (cons card (shuffle (remove-item card deck))) )))

;nth
(define (nth n items)
  (if (= 0 n)
    (car items)
    (nth (- n 1) (cdr items)) ))

;remove
(define (remove-item search items)
  (filter (lambda (element)
            (not (eq? element search)))
          items))

;deck class
(define-class (deck)
              (instance-vars (stack (shuffle ordered-deck)))
              (method (empty?)
                      (null? stack))
              (method (deal)
                      (if (empty? stack)
                        '()
                        (let ((card (car stack)))
                          (begin (set! stack (cdr stack))
                                 card) ))) )
