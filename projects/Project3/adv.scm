;; ADV.SCM
;; This file contains the definitions for the objects in the adventure
;; game and some utility procedures.

(define-class (basic-object)
  (instance-vars (properties (make-table)))
  (method (put key value)
    (insert! key value properties))
  (default-method
    (lookup message properties)) )

(define-class (place name)
  (parent (basic-object))
  (instance-vars
   (directions-and-neighbors '())
   (things '())
   (people '())
   (entry-procs '())
   (exit-procs '()))
  (method (may-enter? person) #t)
  (method (type) 'place)
  (method (place?) #t)
  (method (neighbors) (map cdr directions-and-neighbors))
  (method (exits) (map car directions-and-neighbors))
  (method (look-in direction)
    (let ((pair (assoc direction directions-and-neighbors)))
      (if (not pair)
	  '()                     ;; nothing in that direction
	  (cdr pair))))           ;; return the place object
  (method (appear new-thing)
    (if (memq new-thing things)
	(error "Thing already in this place" (list name new-thing)))
    (set! things (cons new-thing things))
    'appeared)
  (method (enter new-person)
    (if (memq new-person people)
	(error "Person already in this place" (list name new-person)))
    (for-each (lambda (person) (ask person 'notice new-person)) people)
    (set! people (cons new-person people))
    (for-each (lambda (proc) (proc)) entry-procs)
    'appeared)
  (method (gone thing)
    (if (not (memq thing things))
	(error "Disappearing thing not here" (list name thing)))
    (set! things (delete thing things)) 
    'disappeared)
  (method (exit person)
    (for-each (lambda (proc) (proc)) exit-procs)
    (if (not (memq person people))
	(error "Disappearing person not here" (list name person)))
    (set! people (delete person people)) 
    'disappeared)

  (method (new-neighbor direction neighbor)
    (if (assoc direction directions-and-neighbors)
	(error "Direction already assigned a neighbor" (list name direction)))
    (set! directions-and-neighbors
	  (cons (cons direction neighbor) directions-and-neighbors))
    'connected)

  (method (add-entry-procedure proc)
    (set! entry-procs (cons proc entry-procs)))
  (method (add-exit-procedure proc)
    (set! exit-procs (cons proc exit-procs)))
  (method (remove-entry-procedure proc)
    (set! entry-procs (delete proc entry-procs)))
  (method (remove-exit-procedure proc)
    (set! exit-procs (delete proc exit-procs)))
  (method (clear-all-procs)
    (set! exit-procs '())
    (set! entry-procs '())
    'cleared) )

(define-class (locked-place init-name)
  (parent (place init-name))
  (instance-vars (unlocked? #f))
  (method (unlock) (set! unlocked? #t))
  (method (may-enter? person) unlocked?) )

(define-class (restaurant init-name specialty price)
  (parent (place init-name))
  (instance-vars (menu '()))
  (initialize (set! menu (cons (cons specialty price)
                               menu)))
  ;; We'll assume for now that a restaurants' specialty is always
  ;; the only item in the menu
  (method (sell customer food)
          (let ((menu-items (filter (lambda (menu-item)
                                      (eq? (car menu-item) food))
                                    (ask self 'menu))))
            (cond ((null? menu-items) #f)
                  ((or (eq? 'police
                            (ask customer 'type))
                       (ask customer 'pay-money (cdar menu-items)))
                   ;;500 is a placeholder for calories
                   (instantiate food 500))
                  (else #f)))) )

(define-class (hotspot init-name password)
  (parent (place init-name))
  (instance-vars (devices '()))
  (method (connect laptop pass)
    (cond ((not (memq laptop (ask self 'things))) (error "laptop not in hotspot")) 
          ((equal? pass password) (set! devices (cons laptop devices)))
          (else (error "Password is incorrect")) ))
  (method (gone thing)
    (begin (usual 'gone thing)
    (if (memq thing devices)
      (set! devices (delete thing devices)) )
    'disappeared))
  (method (surf laptop url)
    (if (memq laptop devices)
      (system (string-append "lynx " url))
      (error "laptop not connected to wi-fi"))) )

(define-class (person name place)
  (parent (basic-object))
  (instance-vars
   (possessions '())
   (saying ""))
  (initialize
   (ask self 'put 'strength 50)
   (ask self 'put 'money 100)
   (ask place 'enter self))
  (method (type) 'person)
  (method (person?) #t)
  (method (look-around)
    (map (lambda (obj) (ask obj 'name))
	 (filter (lambda (thing) (not (eq? thing self)))
		 (append (ask place 'things) (ask place 'people)))))
  (method (take thing)
    (cond ((not (thing? thing)) (error "Not a thing" thing))
	  ((not (memq thing (ask place 'things)))
	   (error "Thing taken not at this place"
		  (list (ask place 'name) thing)))
	  ((memq thing possessions) (error "You already have it!"))
	  ((eq? (ask thing 'possessor) 'no-one)
	     (announce-take name thing)
	     (set! possessions (cons thing possessions))
         (ask thing 'change-possessor self)
	     'taken)
	   ;; If somebody already has this object...
       ((memq (ask thing 'possessor) (ask place 'people))
       ;;(newline)
       ;;(display "Taken - PEOPLE IN AREA")
       ;;(display (ask place 'people))
       ;;(newline)
	   (for-each
	    (lambda (pers)
	      (if (and (not (eq? pers self)) ; ignore myself
		       (memq thing (ask pers 'possessions))
               (ask thing 'may-take? self))
		  (begin
	       (announce-take name thing)
           (set! possessions (cons thing possessions))
		   (ask pers 'lose thing)
		   (have-fit pers)
           (ask thing 'change-possessor self)
           'taken)))
	    (ask place 'people)))
       (else
         (let ((pers (ask thing 'possessor)))
         (if (ask thing 'may-take? self)
           (begin
	         (announce-take name thing)
             (set! possessions (cons thing possessions))
		     (ask pers 'lose thing)
		     (have-fit pers)
             (ask thing 'change-possessor self))
           (begin
             (newline)
             (display "Too weak to steal ")
             (display (ask thing 'name))
             (display "from ")
             (display pers)
             (newline)
             (display (ask pers 'strength))
             (display " vs ")
             (display (ask self 'strength))) ))) ))
  (method (lose thing)
    (set! possessions (delete thing possessions))
    (ask thing 'change-possessor 'no-one)
    'lost)
  (method (talk) (print saying))
  (method (set-talk string) (set! saying string))
  (method (exits) (ask place 'exits))
  (method (notice person) (ask self 'talk))
  (method (eat)
    (let ((strength (ask self 'strength))
          (food-items (filter (lambda (possession)
                                (ask possession 'edible?))
                              possessions)))
      (if (null? food-items)
        '(nothing to eat)
        (begin (ask self 'put 'strength (+ strength
                                           (accumulate + 0
                                             (map (lambda (item)
                                                    (ask item 'calories))
                                                  food-items))))
               (map (lambda (meal)
                      (begin (ask self 'lose meal)
                             (ask place 'gone meal)))
                    food-items)
               'ate) )))
  (method (go direction)
    (let ((new-place (ask place 'look-in direction)))
      (cond ((null? new-place)
	     (error "Can't go" direction))
        ((not (ask new-place 'may-enter? self))
         (error (ask new-place 'name) " is locked"))
	    (else
	     (ask place 'exit self)
	     (announce-move name place new-place)
	     (for-each
	      (lambda (p)
		(ask place 'gone p)
		(ask new-place 'appear p))
	      possessions)
	     (set! place new-place)
	     (ask new-place 'enter self)))))
  (method (go-directly-to new-place)
    (cond ((null? new-place) (error "Can't go directly to" place))
          ((not (ask new-place 'may-enter? self))
          (error (ask new-place 'name) " is locked"))
          (else
            (announce-move name place new-place)
            (for-each
              (lambda (p)
                (ask place 'gone p)
                (ask new-place 'appear p))
              possessions)
            (set! place new-place)
            (ask new-place 'enter self)) ))
  (method (take-all) (begin
                       (map (lambda (item)
                              (if (equal? 'no-one (ask item 'possessor))
                                (ask self 'take item)))
                            (ask place 'things))
                       'done))
  (method (get-money amount) (ask self 'put 'money (+ amount
                                                      (ask self 'money))))
  (method (pay-money amount) (if (>= (ask self 'money) amount)
                               (begin
                                 (ask self 'put 'money (- (ask self 'money)
                                                          amount))
                                 #t)
                               #f))
  (method (buy food-name)
    (let* ((menu (ask (ask self 'place) 'menu))
           (menu-items (filter (lambda (menu-item)
                                 (eq? (ask (car menu-item) 'name) food-name))
                               menu))
           (purchase (if (not (null? menu-items))
                       (ask place 'sell self (caar menu-items))
                       #f)) )
      (if purchase
        (begin (ask place 'appear purchase)
               (ask self 'take purchase))
        #f) )) )

(define thing
  (let ()
    (lambda (class-message)
      (cond
       ((eq? class-message 'instantiate)
	(lambda (name)
	  (let ((self '())
            (possessor 'no-one)
            (my-basic-object (instantiate-parent basic-object)))
	    (define (dispatch message)
	      (cond
	       ((eq? message 'initialize)
		(lambda (value-for-self)
		  (set! self value-for-self)
          (ask my-basic-object 'initialize self)))
	       ((eq? message 'send-usual-to-parent)
              (lambda (message . args)
                (let ((method (get-method 'thing message my-basic-object)))
                  (if (method? method)
                    (apply method args)
                    (error "No USUAL method" message 'thing))) ))
	       ((eq? message 'name) (lambda () name))
	       ((eq? message 'possessor) (lambda () possessor))
	       ((eq? message 'type) (lambda () 'thing))
	       ((eq? message 'thing?) (lambda () #t))
	       ((eq? message 'may-take?)
              (lambda (receiver)
                (let ((attacker (ask receiver 'strength))
                      (defender (ask possessor 'strength)))
                  (if (> attacker defender)
                    self
                    #f) )))
	       ((eq? message 'change-possessor)
		(lambda (new-possessor)
		  (set! possessor new-possessor)))
	       (else (let ((method (get-method 'thing message my-basic-object)))
                   (if (method? method)
                     method
                     (lambda args 'sorry))))))
	    dispatch)))
       (else (error "Bad message to class" class-message))))))

(define-class (laptop laptop-name)
  (parent (thing laptop-name))
  (method (connect password)
    (ask (ask (ask self 'possessor) 'place) 'connect self password))
  (method (surf url)
    (ask (ask (ask self 'possessor) 'place) 'surf self url)) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Implementation of thieves for part two
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *foods* '(pizza potstickers coffee))

(define (edible? thing)
  (ask thing 'edible?))

(define-class (thief name initial-place)
  (parent (person name initial-place))
  (instance-vars
   (behavior 'steal))
  (initialize
   (ask self 'put 'strength 75))
  (method (type) 'thief)
  (method (notice person)
    (if (eq? behavior 'run)
      (let ((chosen-exit (pick-random (ask (usual 'place) 'exits))))
        (if chosen-exit
          (ask self 'go chosen-exit)
          '(NO EXITS)))
      (let ((food-things
              (filter (lambda (thing)
                        (and (edible? thing)
                             (not (eq? (ask thing 'possessor) self))))
                      (ask (usual 'place) 'things))))
        (if (not (null? food-things))
          (begin
            (ask self 'take (car food-things))
            (set! behavior 'run)
            (ask self 'notice person)) )))) )

(define-class (police name initial-place)
  (parent (person name initial-place))
  (initialize
   (ask self 'put 'strength 100))
  (method (type) 'police)
  (method (notice person)
    (if (eq? (ask person 'type) 'thief)
      (begin (ask self 'set-talk "Crime Does Not Pay")
             (ask self 'talk)
             (map (lambda (possession)
                    (ask self 'take possession))
                  (ask person 'possessions))
             (ask person 'go-directly-to jail) ) )) )
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; this next procedure is useful for moving around

(define (move-loop who)
  (newline)
  (print (ask who 'exits))
  (display "?  > ")
  (let ((dir (read)))
    (if (equal? dir 'stop)
	(newline)
	(begin (ask who 'go dir)
	       (move-loop who)))))


;; One-way paths connect individual places.

(define (can-go from direction to)
  (ask from 'new-neighbor direction to))


(define (announce-take name thing)
  (newline)
  (display name)
  (display " took ")
  (display (ask thing 'name))
  (newline))

(define (announce-move name old-place new-place)
  (newline)
  (newline)
  (display name)
  (display " moved from ")
  (display (ask old-place 'name))
  (display " to ")
  (display (ask new-place 'name))
  (newline))

(define (have-fit p)
  (newline)
  (display "Yaaah! ")
  (display (ask p 'name))
  (display " is upset!")
  (newline))


;;(define (pick-random set)
  ;;(nth (random (length set)) set))

(define (pick-random set)
  (list-ref set (random (length set))))

(define (delete thing stuff)
  (cond ((null? stuff) '())
	((eq? thing (car stuff)) (cdr stuff))
	(else (cons (car stuff) (delete thing (cdr stuff)))) ))

(define (person? obj)
  (and (procedure? obj)
       (ask obj 'person?)))

(define (thing? obj)
  (and (procedure? obj)
       (ask obj 'thing?)))

(define (place? obj)
  (and (procedure? obj)
       (ask obj 'place?)))

;;Alternate functions
;; Person
;; Specifically request to take the thing from person's inventory
;; Backup in case previous version is glitchy
       ;;(else 
	   ;;(for-each
	    ;;(lambda (pers)
	      ;;(let ((owned-thing (memq thing (ask pers 'possessions))))
             ;;(if (and (not (eq? pers self)) ; ignore myself
                      ;;owned-thing
                      ;;(ask owned-thing 'may-take? self))
               ;;(begin
	           ;;(announce-take name ownend-thing)
               ;;(set! possessions (cons ownend-thing possessions))
		       ;;(ask pers 'lose ownend-thing)
		       ;;(have-fit pers)
               ;;(ask ownend-thing 'change-possessor self)
               ;;'taken))))
	    ;;(ask place 'people)) )))

  ;;(method (go-directly-to new-place)
    ;;(cond ((null? new-place) (error "Can't go directly to" place))
          ;;((not (ask new-place 'may-enter? self))
          ;;(error (ask new-place 'name) " is locked"))
          ;;(else
            ;;(ask place 'exit self)
            ;;(announce-move name place new-place)
            ;;(for-each
              ;;(lambda (p)
                ;;(ask place 'gone p)
                ;;(ask new-place 'appear p))
              ;;possessions)
            ;;(set! place new-place)
            ;;(ask new-place 'enter self)) ))
