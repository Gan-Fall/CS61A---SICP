;Ver 1 accidentally thought deposit took a list of coins
(define-class (coke-machine room price)
              (instance-vars (cans 0) (money 0))
              ;todo: deposit coke fill
              (method (deposit . coins)
                      (if (not (null? coins))
                        (begin (set! money (+ (car coins) money))
                               (ask self 'deposit (cdr coins)) )))
;Ver 2
(define-class (coke-machine room price)
              (instance-vars (cans 0) (change 0))
              ;todo: fill
              (method (deposit coin)
                      (set! change (+ change coin)))
              (method (coke)
                      (cond ((= cans 0) '(Machine empty))
                            ((< change price) '(Not enough money))
                            (else (begin (set! cans (- cans 1))
                                         (set! change (- change price))
                                         change)) ))
              (method (fill amount)
                      (if (> (+ amount cans) room)
                        '(Not enough room for those cans!)
                        (set! cans (+ cans amount)) )) )
