;; Code for CS61A project 2 -- picture language
(define (split split-direction split-alignment)
  (define (helper painter n)
    (if (= n 0)
      painter
      (let ((resultant (helper painter (- n 1))))
        (split-direction painter
                         (split-alignment resultant
                                          resultant))) ))
  (lambda (painter n) (helper painter n)) )

(define make-vect cons)
(define xcor-vect car)
(define ycor-vect cdr)

(define (add-vect vect1 vect2)
  (make-vect (+ (xcor-vect vect1) (xcor-vect vect2))
             (+ (ycor-vect vect1) (ycor-vect vect2))))

(define (sub-vect vect1 vect2)
  (make-vect (- (xcor-vect vect1) (xcor-vect vect2))
             (- (ycor-vect vect1) (ycor-vect vect2))))

(define (scale-vect scalar vect)
  (make-vect (* (xcor-vect vect) scalar)
             (* (ycor-vect vect) scalar)))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define origin-frame car)
(define edge1-frame cadr)
(define edge2-frame cddr)

(define (square-limit painter n)
  (let ((combine4 (square-of-four flip-horiz identity
				  rotate180 flip-vert)))
    (combine4 (corner-split painter n))))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
			   (edge1-frame frame))
	       (scale-vect (ycor-vect v)
			   (edge2-frame frame))))))

(define make-segment cons)
(define start-segment car)
(define end-segment cdr)

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
	((frame-coord-map frame) (start-segment segment))
	((frame-coord-map frame) (end-segment segment))))
     segment-list)))

(define (draw-line v1 v2)
  (penup)
  (setxy (- (* (xcor-vect v1) 200) 100)
	 (- (* (ycor-vect v1) 200) 100))
  (pendown)
  (setxy (- (* (xcor-vect v2) 200) 100)
	 (- (* (ycor-vect v2) 200) 100)))

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

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
	(painter
	 (make-frame new-origin
		     (sub-vect (m corner1) new-origin)
		     (sub-vect (m corner2) new-origin)))))))

(define (flip-horiz painter)
  (transform-painter
    painter
    (make-vect 1 0)
    (make-vect 0 0)
    (make-vect 1 1) ))

(define (flip-vert painter)
  (transform-painter painter
		     (make-vect 0.0 1.0)
		     (make-vect 1.0 1.0)
		     (make-vect 0.0 0.0)))

(define (shrink-to-upper-right painter)
  (transform-painter painter
		    (make-vect 0.5 0.5)
		    (make-vect 1.0 0.5)
		    (make-vect 0.5 1.0)))

(define (rotate90 painter)
  (transform-painter painter
		     (make-vect 1.0 0.0)
		     (make-vect 1.0 1.0)
		     (make-vect 0.0 0.0)))

(define (rotate180 painter)
  (transform-painter
    painter
    (make-vect 1 1)
    (make-vect 0 1)
    (make-vect 1 0) ))

(define (rotate270 painter)
  (transform-painter
    painter
    (make-vect 0 1)
    (make-vect 0 0)
    (make-vect 1 1) ))

(define (squash-inwards painter)
  (transform-painter painter
		     (make-vect 0.0 0.0)
		     (make-vect 0.65 0.35)
		     (make-vect 0.35 0.65)))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
	   (transform-painter painter1
			      (make-vect 0.0 0.0)
			      split-point
			      (make-vect 0.0 1.0)))
	  (paint-right
	   (transform-painter painter2
			      split-point
			      (make-vect 1.0 0.0)
			      (make-vect 0.5 1.0))))
      (lambda (frame)
	(paint-left frame)
	(paint-right frame)))))

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

(define (flipped-pairs painter)
  (let ((painter2 (beside painter (flip-vert painter))))
    (below painter2 painter2)))

(define full-frame (make-frame (make-vect -0.5 -0.5)
			       (make-vect 2 0)
			       (make-vect 0 2)))

(define (identity x) x)

(define (flipped-pairs painter)
  (let ((combine4 (square-of-four identity flip-vert
				  identity flip-vert)))
    (combine4 painter)))

;; or

; (define flipped-pairs
;   (square-of-four identity flip-vert identity flip-vert))

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
	(beside painter (below smaller smaller)))))

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
	    (right (right-split painter (- n 1))))
	(let ((top-left (beside up up))
	      (bottom-right (below right right))
	      (corner (corner-split painter (- n 1))))
	  (beside (below painter top-left)
		  (below bottom-right corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
	  (bottom (beside (bl painter) (br painter))))
      (below bottom top))))
