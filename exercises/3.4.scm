(define (make-account balance password)
  (define attempts 0)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance 
                     (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (cond ((eq? p password)
           (cond ((eq? m 'withdraw) withdraw)
                 ((eq? m 'deposit) deposit)
                 (else (error "Unknown request: 
                              MAKE-ACCOUNT" m))))
            (else (set! attempts (+ 1 attempts))
                  (if (> attempts 7) (call-the-cops))
                  (lambda (.x) "Password is incorrect"))))
  dispatch)
