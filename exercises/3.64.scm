(define (stream-limit s tolerance)
  (cond ((stream-null? (stream-car s)) the-empty-stream)
        ((stream-null? (stream-car (stream-cdr s))) the-empty-stream)
        (else (let ((x (stream-car s))
                    (y (stream-car (stream-cdr s))))
                (if (< (abs (- x y)) tolerance)
                  y
                  (stream-limit (stream-cdr (stream-cdr s)) tolerance) )))))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 
     1.0 (stream-map
          (lambda (guess)
            (sqrt-improve guess x))
          guesses)))
  guesses)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))
