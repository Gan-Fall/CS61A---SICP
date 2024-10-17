(define (substitute sent oldwd newwd)
  (every (lambda (wd) (if (equal? wd oldwd)
                        newwd
                        wd)) sent))
