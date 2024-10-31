;1
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define origin-frame car)
(define edge1-frame cadr)
(define edge2-frame caddr)

;2
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define origin-frame car)
(define edge1-frame cadr)
(define edge2-frame cddr)
