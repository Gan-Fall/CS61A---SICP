(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;A
(define left-branch car)
(define right-branch cadr)
(define branch-length car)
(define branch-structure cadr)

;B
(define (total-weight mobile)
  (let ((left-structure (branch-structure (left-branch mobile)))
	(right-structure (branch-structure (right-branch mobile))))
  (cond ((null? mobile) 0)
	((and (number? left-structure)
	      (number? right-structure)) (+ left-structure right-structure))
	((number? left-structure) (+ left-structure (total-weight right-structure)))
	((number? right-structure) (+ right-structure (total-weight left-structure)))
	(else (+ (total-weight left-structure) (total-weight right-structure))) )))

;C
;just realized I misunderstood the question and total-length was totally unnecessary
(define (total-length mobile)
  (let ((left-structure (branch-structure (left-branch mobile)))
	(right-structure (branch-structure (right-branch mobile)))
	(left-length (branch-length (left-branch mobile)))
	(right-length (branch-length (right-branch mobile))))
  (cond ((null? mobile) 0)
	((and (number? left-structure)
	      (number? right-structure)) (+ left-length right-length))
	((number? left-structure) (+ left-length right-length (total-length right-structure)))
	((number? right-structure) (+ left-length right-length (total-length left-structure)))
	(else (+ left-length right-length (total-length left-structure) (total-length right-structure))) )))

(define (balanced? mobile)
  (let ((left-structure (branch-structure (left-branch mobile)))
	(right-structure (branch-structure (right-branch mobile))))
  (if (= (torque (left-branch mobile))
	 (torque (right-branch mobile)))
       (cond ((and (number? left-structure) (number? right-structure)) #t)
	     ((and (not (number? left-structure)) (not (number? right-structure))) (and (balanced? left-structure) (balanced? right-structure)))
	     ((number? left-structure) (balanced? right-structure))
	     ((number? right-structure) (balanced? left-structure))
	     (else #t) )
       #f)))

(define (torque branch)
  (if (number? (branch-structure branch))
    (* (branch-length branch) (branch-structure branch))
    (* (branch-length branch) (total-weight (branch-structure branch))) ))

;D
(define right-branch cdr)
(define branch-structure cdr)

;Attempt 2
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;A
(define left-branch car)
(define right-branch cadr)
(define branch-length car)
(define branch-structure cadr)

;B
(define (total-weight mobile)
    (+ (branch-weight (left-branch mobile))
       (branch-weight (right-branch mobile))))

(define (branch-weight branch)
  (let ((struct (branch-structure branch)))
    (if (number? struct)
      struct
      (total-weight struct))))

;C
(define (balanced? mobile)
  (and (= (torque (left-branch mobile))
	  (torque (right-branch mobile)))
       (balanced-branch? (left-branch mobile))
       (balanced-branch? (right-branch mobile))))

(define (torque branch)
  (* (branch-length branch) (branch-weight branch)))

(define (balanced-branch? branch)
  (let ((struct (branch-structure branch)))
    (if (number? struct)
      #t
      (balanced? struct))))

;D
(define right-branch cdr)
(define branch-structure cdr)
