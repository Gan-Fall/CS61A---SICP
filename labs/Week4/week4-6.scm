;2.2
(define (make-point x y)
  (cons x y))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (make-segment start end)
  (cons start end))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

(define (average x y)
  (/ (+ x y) 2))

(define (midpoint-segment segment)
  (let ((a (start-segment segment))
        (b (end-segment segment)))
        (let ((x1 (x-point a))
        (x2 (x-point b))
        (y1 (y-point a))
        (y2 (y-point b)))
          (make-point (average x1 x2) (average y1 y2))) ))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;2.3
;ver 1 - rectangle is a segment created with a given height, width, and starting coordinate
(define (make-rectangle W H start-point)
  (let ((x (x-point start-point))
        (y (y-point start-point)))
    (make-segment start-point
                  (make-point (+ x W) (+ y H))) ))

(define (rectangle-origin rectangle)
  (start-segment rectangle))

(define (rectangle-endpoint rectangle)
  (end-segment rectangle))

(define (rectangle-width rectangle)
  (- (x-point (rectangle-endpoint rectangle)) (x-point (rectangle-origin rectangle))))

(define (rectangle-height rectangle)
  (- (y-point (rectangle-endpoint rectangle)) (y-point (rectangle-origin rectangle))))

(define (rectangle-center rectangle)
  (midpoint-segment rectangle))

(define (rectangle-coordinates rectangle)
  (let ((a (rectangle-origin rectangle))
        (b (rectangle-endpoint rectangle)))
        (let ((x1 (x-point a))
        (x2 (x-point b))
        (y1 (y-point a))
        (y2 (y-point b)))
          (list a
                (make-point x2 y1)
                b
                (make-point x1 y2)) )))

(define (rectangle-perimeter rectangle)
  (+ (* 2 (rectangle-width rectangle)) (* 2 (rectangle-height rectangle))))

(define (rectangle-area rectangle)
  (* (rectangle-width rectangle) (rectangle-height rectangle)))

;ver 2 - rectangle is a segment created with a given height, width, and starting coordinate

;2.4
(define (cons x y) 
  (lambda (m) (m x y)))

(define (car z) 
  (z (lambda (p q) p)))

(define (cdr z) 
  (z (lambda (p q) q)))
