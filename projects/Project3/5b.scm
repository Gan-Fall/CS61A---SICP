(define Alejandro (instantiate person 'Alejandro Noahs))
(define Katana (instantiate laptop 'Katana))
(define Food-Court (instantiate hotspot 'Food-Court 'Password123))
(can-go Noahs 'east Food-Court)
(can-go Food-Court 'west Noahs)
(ask Noahs 'appear Katana)
(ask Alejandro 'take Katana)

(ask Katana 'connect 'wrongpswd)
(ask Katana 'connect 'Password123)

(ask Alejandro 'go 'east)

(ask Katana 'connect 'wrongpswd)
(ask Katana 'connect 'Password123)

(ask Food-Court 'devices)

(ask Katana 'surf "http://www.cs.berkeley.edu")
(ask Alejandro 'go 'west)

(ask Food-Court 'devices)
(ask Katana 'surf "http://www.cs.berkeley.edu")
(ask Katana 'connect 'Password123)
(ask Katana 'surf "http://www.cs.berkeley.edu")

(ask Alejandro 'go 'east)
(ask Food-Court 'things)
(ask Food-Court 'devices)
