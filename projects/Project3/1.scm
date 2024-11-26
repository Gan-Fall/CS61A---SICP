(define Dormitory (instantiate place 'Dormitory))
(define Kirin (instantiate place 'Kirin))

(define potstickers (instantiate thing 'potstickers))
(ask Kirin 'appear potstickers)

(define Alejandro (instantiate person 'Alejandro Dormitory))

(can-go Dormitory 'west Telegraph-Ave)
(can-go Telegraph-Ave 'east Dormitory)
(can-go Kirin 'south Soda)
(can-go Soda 'north Kirin)

;move to Kirin
(ask Alejandro 'go 'west)
(ask Alejandro 'go 'north)
(ask Alejandro 'go 'north)
(ask Alejandro 'go 'north)

(ask Alejandro 'take potstickers)

;move to BH-Office
(ask Alejandro 'go 'south)
(ask Alejandro 'go 'up)
(ask Alejandro 'go 'west)

;METHOD 1: Set down potstickers manually
(ask Alejandro 'lose potstickers)
(ask BH-Office 'appear potstickers)

;METHOD 2: Define a put-down procedure
(define (put-down person thing)
  (let ((place (ask person 'place)))
    (begin (ask person 'lose thing)
           (ask place 'appear thing)
           'PLACED )))
(put-down Alejandro potstickers)

(ask Brian 'take potstickers)

;Go to CS61A lab
(ask Alejandro 'go 'east)
(ask Alejandro 'go 'down)
(ask Alejandro 'go 'south)
(ask Alejandro 'go 'south)
