(define (make-table)
  (list 'table))

(define (assoc key records)
  (cond ((null? records) #f)
        ((equal? key (caar records)) 
         (car records))
        (else (assoc key (cdr records)))))

(define (insert! value table . keys)
  (define (insert-record!)
    (let ((record (assoc (car keys) (cdr table))))
      (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons (car keys) value)
                        (cdr table)))) ))
  (define (insert-table!)
    (let ((subtable (assoc (car keys) (cdr table))))
      (if subtable
        (insert! value subtable (cdr keys))
        (begin
          (set-cdr! table
                  (cons (list (car keys))
                        (cdr table)))
          (insert! value (car (cdr table)) (cdr keys))) )))
  (cond ((null? keys) (error "No keys provided - INSERT!"))
        ((null? (cdr keys)) (insert-record!))
        (else (insert-table!))) )

(define (lookup table . keys)
  (define get (assoc (car keys) (cdr table)))
  (define (lookup-record)
    (if get
      (cdr get)
      #f))
  (define (lookup-table)
    (if get
      (lookup get (cdr keys))
      #f))
  (cond ((null? keys) (error "No keys provided - LOOKUP"))
        ((null? (cdr keys)) (lookup-record))
        (else (lookup-table)) ))

;Alternate (Better) version

(define (lookup keylist table)
  (cond    ; *** the clause ((not table) #f) is no longer needed
   ((null? keylist) (car table))        ; ***
   (else (let ((record (assoc (car keylist) (cdr table))))
           (if (not record)
               #f
               (lookup (cdr keylist) (cdr record))))))) ; ***

(define (insert! keylist value table)
  (if (null? keylist)
      (set-car! table value)    ; ***
      (let ((record (assoc (car keylist) (cdr table))))
        (if (not record)
            (begin
             (set-cdr! table
                       (cons (list (car keylist) #f) (cdr table))) ; ***
             (insert! (cdr keylist) value (cdadr table)))
            (insert! (cdr keylist) value (cdr record))))))
