;1
(define painter-smiley
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
         (make-segment (make-vect 0.45 0.75) (make-vect 0.5 0.7))
         (make-segment (make-vect 0.5 0.7) (make-vect 0.55 0.75))
         (make-segment (make-vect 0.65 0.85) (make-vect 0.6 1))) ))

;2
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter 
                                (- n 1))))
          (beside (below painter up)
                  (below right 
                         corner)))))

;3
;ver 1
(define (square-limit painter n)
  (let ((combine4 
         (square-of-four identity 
                         flip-horiz
                         flip-vert 
                         rotate180)))
    (combine4 (corner-split painter n))))

;ver 2
(define (square-limit painter n)
  (let ((combine4 
         (square-of-four flip-horiz 
                         identity
                         rotate180 
                         flip-vert)))
    (combine4 (corner-split (flip-horiz painter) n))))
