(define potstickers (instantiate thing 'potstickers))
(ask Noahs 'appear potstickers)
(define cinnamon-roll (instantiate thing 'cinnamon-roll))
(ask Noahs 'appear cinnamon-roll)
(define waffles (instantiate thing 'waffles))
(ask Noahs 'appear waffles)

(define Alejandro (instantiate person 'Alejandro Noahs))
(define Soumen (instantiate person 'Soumen Noahs))

(ask Soumen 'take cinnamon-roll)
(ask Alejandro 'take-all)

(inventory Alejandro)
(inventory Soumen)
