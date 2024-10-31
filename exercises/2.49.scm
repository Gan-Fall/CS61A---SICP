(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) 
         (start-segment segment))
        ((frame-coord-map frame) 
         (end-segment segment))))
     segment-list)))

;1
(define painter-outline
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 0 1))
                           (make-segment (make-vect 0 1) (make-vect 1 1))
                           (make-segment (make-vect 1 1) (make-vect 1 0))
                           (make-segment (make-vect 1 0) (make-vect 0 0))) ))

;2
(define painter-x
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 1 1))
                           (make-segment (make-vect 0 1) (make-vect 1 0))) ))

;3
(define painter-diamond
  (segments->painter (list (make-segment (make-vect 0.5 0) (make-vect 1 0.5))
                           (make-segment (make-vect 1 0.5) (make-vect 0.5 1))
                           (make-segment (make-vect 0.5 1) (make-vect 0 0.5))
                           (make-segment (make-vect 0 0.5) (make-vect 0.5 0))) ))

;4
(define painter-wave
  (segments->painter
   (list (make-segment (make-vect 0.4 1) (make-vect 0.35 0.85))
         (make-segment (make-vect 0.35 0.85) (make-vect 0.4 0.65))
         (make-segment (make-vect 0.4 0.65) (make-vect 0.3 0.65))
         (make-segment (make-vect 0.3 0.65) (make-vect 0.15 0.6))
         (make-segment (make-vect 0.15 0.6) (make-vect 0 0.85))
         (make-segment (make-vect 0 0.65) (make-vect 0.15 0.4))
         (make-segment (make-vect 0.15 0.4) (make-vect 0.3 0.6))
         (make-segment (make-vect 0.3 0.6) (make-vect 0.35 0.5))
         (make-segment (make-vect 0.35 0.5) (make-vect 0.25 0))
         (make-segment (make-vect 0.4 0) (make-vect 0.5 0.3))
         (make-segment (make-vect 0.5 0.3) (make-vect 0.6 0))
         (make-segment (make-vect 0.75 0) (make-vect 0.6 0.45))
         (make-segment (make-vect 0.6 0.45) (make-vect 1 0.15))
         (make-segment (make-vect 1 0.35) (make-vect 0.75 0.65))
         (make-segment (make-vect 0.75 0.65) (make-vect 0.6 0.65))
         (make-segment (make-vect 0.6 0.65) (make-vect 0.65 0.85))
         (make-segment (make-vect 0.65 0.85) (make-vect 0.6 1))) ))
