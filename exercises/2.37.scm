(define sample-matrix (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

;The column becomes the row
(define (transpose mat)
  (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (map (lambda (column) (dot-product row column)) cols)) m)))
