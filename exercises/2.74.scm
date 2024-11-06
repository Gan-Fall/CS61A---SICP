(define (get-file-division file)
  (apply-generic 'division file))

(define (get-record employee-name file)
  (let ((division (get-file-division file)))
    ((get 'record division) employee-name file)))

(define (get-salary employee-record division)
  ((get 'salary division) employee-record))

(define (find-employee-record employee files)
  (if (not (null? files))
    (let ((try (get-record employee (car files))))
      (if try
          try
          (find-employee-record employee (cdr files))))
    #f))
