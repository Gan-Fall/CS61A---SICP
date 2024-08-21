; Version 1, kind of a cheat since I used lambda
(define (dupls-removed sent)
  (if (empty? sent)
    sent
    (se (first sent) (dupls-removed (keep (lambda (wd) (not (equal? wd (first sent)))) sent)))))

;Version 2
(define (rm-firstwd sent)
  (define (helper result)
    (cond ((empty? result) result)
          ((equal? (first sent) (first result))
              (helper (bf result)))
          (else (se (first result) (helper (bf result))))))
  (helper sent))

(define (dupls-removed sent)
  (if (empty? sent)
    sent
    (se (first sent) (dupls-removed (rm-firstwd sent)))))
