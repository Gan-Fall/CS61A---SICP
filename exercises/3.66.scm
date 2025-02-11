(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream 
       (stream-car s1)
       (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) 
                  (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

The order in which these pairs are placed into the stream is: start with
an integer in the stream s, create a map which is itself a stream of that
integer and every single possible value of the second integer, interleave
or alternate between that map and a map of the next element in the s stream
and again every element in the t stream equal or higher to the integer in s.
This should generate a pattern like:

(1 1)
(1 2)
(2 2)
(1 3)
(2 3)
(1 4)
(3 3)
(1 5)
(2 4)
(1 6)
(3 4)
(1 7)
(2 5)
(1 8)
(4 4)
(1 9)
(2 6)
(1 10)
(3 5)
(1 11)
(2 7)
(1 12)
(4 5)
(1 13)
(2 8)
(1 14)
(3 6)
(1 15)
.
.
.
and so on infinitely,
Every second element here in the beginning starts with 1 because its going
back to that original map, then when the map for s=2 is created every other
element is going back to the s=1 map then the s=2 map and so on for every
other map created subsequently.

You can think of it like there are these parallel streams happening
---------------------------------------------------------------> S->∞
map (1, t)       map (2, t)      map (3, t)         map (3, t)  ...
|(1 1)
|(1 2)
|                    (2 2)
|(1 3)
|                    (2 3)
|(1 4)
|                                    (3 3)
|(1 5)
|                    (2 4)
|(1 6)
|                                    (3 4)
|(1 7)
|                    (2 5)
|(1 8)
|                                                     (4 4)
|(1 9)
|                    (2 6)
|(1 10)
|                                    (3 5)
|(1 11)
|                    (2 7)
|(1 12)
|                                                     (4 5)
|(1 13)
|                    (2 8)
|(1 14)
|                                    (3 6)
|(1 15)
v
nested Sn
