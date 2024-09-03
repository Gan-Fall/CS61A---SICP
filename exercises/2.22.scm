(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items '()))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square
                     (car things))))))
  (iter items '()))

The function CONS takes the argument retrieved by car first,
this makes it so in the first version, the current iteration squared
number is stored in the answer variable then iterated again,
when the next iteration starts, answer will have one argument: the first
number in the sequence squared, then it will call cons of the square of current
number as the first argument and the list of the remaining items and so on
till it finishes. The key here is that CONS will always be called with the
current iteration as the first item, meaning the last call will appear first
on the list.

The second version is storing the entire list as it is in the current iteration
in car, and the square of the current iteration in cdr. You're effectively
nesting the list "answer" in its state in every iteration within the answer
argument and returning it at the end. The result has the first empty list,
then the second list with the first item, and so on.

To fix it, you can make a recursive version that stores the current square
as car and cdr as the result of the following calls, or make an iterative
version and reverse it at the end.

;working recursive version
(define (square-list items)
  (define (iter things)
    (if (null? things)
        '()
        (cons (square (car things))
                    (iter (cdr things)))))
  (iter items '()))
