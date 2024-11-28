(define Alejandro (instantiate person 'Alejandro Noahs))

(define singer (instantiate person 'rick Sproul-Plaza))

(ask singer 'set-talk "My funny valentine, sweet comic valentine")

(define preacher (instantiate person 'preacher Sproul-Plaza))

(ask preacher 'set-talk "Praise the Lord")

(define street-person (instantiate person 'harry Telegraph-Ave))

(ask street-person 'set-talk "Brother, can you spare a buck")

(ask Alejandro 'go 'north)
(ask Alejandro 'go 'north)
