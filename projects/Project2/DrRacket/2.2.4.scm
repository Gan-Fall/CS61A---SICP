#lang sicp
(#%require sicp-pict)

(define (split split-direction split-alignment)
  (lambda (painter n)
    ((lambda (helper) (helper helper painter n))
     (lambda (helper painter n) (if (= n 0)
       painter
       (let ((resultant (helper helper painter (- n 1))))
         (split-direction painter
                          (split-alignment resultant
                                           resultant))))) ) ))

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter 
                                (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right 
                                   right))
              (corner (corner-split painter 
                                    (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right 
                         corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) 
                        quarter)))
      (below (flip-vert half) half))))