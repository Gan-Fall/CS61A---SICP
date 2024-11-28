;2E
(define-class (thing name)
    (instance-vars (possessor 'no-one))
    (method (type) 'thing)
    (method (change-possessor new-possessor)
            (set! possessor new-possessor)) )

;2F
(define (name obj) (ask obj 'name))
(define (inventory obj)
  (if (person? obj)
      (map name (ask obj 'possessions))
      (map name (ask obj 'things))))

(define (whereis person)
  (if (person? person)
    (name (ask person 'place))
    (error "Not a valid person object - WHEREIS" person) ))

(define (owner thing)
  (if (thing? thing)
    (let ((possessor (ask thing 'possessor)))
      (if (person? possessor)
        (name possessor)
        possessor))
    (error "Not a valid thing object - OWNER" thing) ))

(define (place? obj)
  (and (procedure? obj)
       (eq? (ask obj 'type) 'place)))
