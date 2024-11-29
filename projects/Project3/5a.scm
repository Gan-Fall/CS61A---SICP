(define-class (ticket serial)
  (parent (thing 'ticket)))

(define-class (garage garage-name)
  (parent (place garage-name))
  (class-vars (counter 0))
  (instance-vars (ledger (make-table)))
  (method (park car-thing)
    (if (memq car-thing (ask self 'things))
      (let ((ticket (instantiate ticket counter))
            (car-owner (ask car-thing 'possessor)))
        (begin (set! counter (+ counter 1))
               (insert! (ask ticket 'serial) car-thing ledger)
               (ask self 'appear ticket)
               (ask car-owner 'lose car-thing)
               (ask car-owner 'take ticket)
               'parked) )
      (error "Car is not in the garage - CAR " car-thing)) )
  (method (unpark ticket)
    (if (equal? 'ticket (ask ticket 'name))
      (let ((car-thing (lookup (ask ticket 'serial) ledger))
            (ticket-no (ask ticket 'serial)))
        (if car-thing
          (let ((car-owner (ask ticket 'possessor)))
            (begin (insert! ticket-no #f ledger)
                 (ask car-owner 'lose ticket)
                 (ask car-owner 'take car-thing)
                 'unparked) )
          (error "No car found under ticket number #" ticket-no) ))
      (error "Thing provided is not a ticket - " ticket) )))

;Test
;Test procedures defined in 2.scm
(define P9 (instantiate garage 'P9))
(define Mazda (instantiate thing 'Mazda))
(ask P9 'appear Mazda)

(can-go Telegraph-Ave 'east P9)
(can-go P9 'west Telegraph-Ave)

(define Alejandro (instantiate person 'Alejandro P9))
(ask Alejandro 'take Mazda)

(define (quick-test)
  (display "++++++++++++++++++++++DEBUG++++++++++++++++++++++")
  (newline)
  (display (place? P9))
  (newline)
  (display (whereis Alejandro))
  (newline)
  (display (owner Mazda))
  (newline)
  (display (inventory P9))
  (newline)
  (display (inventory Alejandro))
  (newline)
  (display "++++++++++++++++++++++END++++++++++++++++++++++")
  (newline))

(quick-test)

(ask Alejandro 'go 'west)

(quick-test)

(ask Alejandro 'go 'east)

(ask P9 'park Mazda)

(quick-test)

(ask (car (ask Alejandro 'possessions)) 'name)
(ask (car (ask Alejandro 'possessions)) 'serial)

(ask Alejandro 'go 'west)

(quick-test)

(ask Alejandro 'go 'east)

(ask P9 'unpark (car (ask Alejandro 'possessions)))

(quick-test)
