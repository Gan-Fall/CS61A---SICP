(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

;1
(define (below painter1 painter2)
  (let ((split-point (make-vect 0 0.5)))
    (let ((paint-top (transform-painter
                       painter2
                       split-point
                       (make-vect 1 0.5)
                       (make-vect 0 1)))
          (paint-bottom (transform-painter
                          painter1
                          (make-vect 0 0)
                          (make-vect 1 0)
                          split-point)) )
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)) )))

;2
(define (below painter1 painter2)
  (lambda (frame)
    (rotate270
      (beside (rotate90 painter2)
              (rotate90 painter1))) ))
