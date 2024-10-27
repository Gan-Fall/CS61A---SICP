ITERATIVE VS RECURSIVE:

Recursive has two differnt types: Syntactically recursive, and procedurally
recursive. The former is for when a procedure calls upon itself, and the later
is when the procedure must resolve the subsequent self calls before returning
its final value. Another way to look at it is like, if it can return the final
value it obtained it is usually iterative, if it has to return its final value
to a previous iteration and so on its recursive.

FUNCTIONS & FORMAL PARAMETERS:

So a function is slightly different from a procedure. When a procedure always
returns the same output given the same input, its functional e.g. square. If
it returns a different value sometimes when given the same input, not
functional e.g. random. A good example is f(x) = 2x + 4 and g(x) = 2(x + 2).
These are the same function but different procedures.

Lets look at the format of a function in scheme: (+ 2 3 4)
here +, or any leftmost argument, is the operator, and 2 3 4 are the formal
parameters or operands. So when the interpreter reads a scheme command it will
take the leftmost argument and check what process it is, then apply it to the
remaining arguments. In the earlier f(x) and g(x) x is the formal parameter.

SUBSTITUTION MODEL:

Whenever you have a function like
(define (square x) (* x x))

The substitution model would check the function call as follows:
(square 2)
   ^    ^
   |Parameter
Function

First substitute in the operator for its body
(* x x)
HOWEVER, the program already knows the formal parameter x is 2 cause it was
stored during function call as one of the arguments:
(* 2 2)
4

In the case of higher order functions it will always replace the procedure
**calls** within the body with their own respective bodies.

FIRST CLASS/HIGHER ORDER PROCEDURES:

So whats a higher order function or higher order procedure?
Well in scheme procedures and functions are treated as First Class, this means
like how any other language treats its variables:
- They may be named
- They may be passed as arguments to procedures
- They may be returned as the results of procedures
- They may be included in data structures

A higher order procedure is one which passes other procedures as formal
parameters or returns them.

DATA ABSTRACTION:
Very important concepts too, includes things like constructors and selectors.
Basically you treat data as having special qualities and enforce these
qualities by only cerating them through its special creator function, and
selecting the values of them you would like returned through their special
selector functions.

E.g.
A data abstraction to make rational numbers
(define make-rational cons)
(define numerator car)
(define denominator cdr)

Another good example is how simply.scm handles words and sentences.

CLOSURE & BOX POINTER DIAGRAMS:

So I just sneakily added cons in the previous explanation.
Every language gives a method of "Closure" or the methods by which it allows
you to combine data objects. This is like an array in C or a list in python.

Scheme's method of closure, cons, ties two data objects together and selects
them with either car (top object) or cdr (bottom object).

These can be drawn with a box and pointer diagram:
e.g
(cons 1 2)
(1 . 2)
the dot here is how scheme prints it

x|x
| |
v v
1 2

imagine the xs were two boxes.

incidentally, a null pointer (or lack of pointer) is denoted with a slashed box
(cons 1 nil)
(1)
notice the lack of dot, more on that later
btw nil and '() are equals:
(define nil '())

x|/
|
v
1

Again imagine the slash was a box with a slash in it.

Now these data objects can also be compound data objects:
(cons (cons 1 2) 3)
((1 . 2) 3)

x|x
| |
| v
| 3
v
x|x
| |
v v
1 2

Something special happens when the second, or cdr, object is itself a compound
data object, notice it begins to look like a linked list.
(cons 1 (cons 2 3))
(1 (2 . 3))

x|x --> x|x
|       | |
v       v v
1       2 3

Well, to make it a linked list and for scheme to recognize it as so, it needs
to end on a null pointer box or a box where the second pointer is null:
(cons 1
   (cons 2
      (cons 3
         (cons 4 nil))))
(1 2 3 4)

this is equivalent to (list 1 2 3 4)

notice the lack of dot in the returned value

In scheme cdr will return the second object in a value with the dot notation
e.g (1 . 2) will return 2
but for objects without dot notation, it will return the "rest"
or everything that isn't the first object

e.g. (cdr (list 1 2 3 4))
(2 3 4)

but anyways back to the pointer diagram for (1 2 3 4)
x|x --> x|x --> x|x --> x|/
|       |       |       |
v       v       v       v
1       2       3       4

Here we have a linked list *ta-da*

PROGRAM EFFICIENCY AND BIG O, THETA, AND GAMMA NOTATION:
One last thing the course covered is program efficiency and big O or theta
notation.

Basically this is a method for calculating how many resources (space [memory]
or time) the program will use. More details on memory big O later  with trees.
For now time is just how many times the program performs an operation.

We use n to denote the input size and how it affects the performance related
to its growth.

If the function runs once or a set amount of times always its O(1).
If the function runs as many times as the input its O(n)
If the function is O(n) but inside it also calls a function that runs
O(n) times every operation it becomes O(n^2).

These were the main ones taught for now but there are cases such as n^3, nlogn,
etc. More on that after trees.

Notice that we are only conserned with large input valuse or large values of n.
As such O(n^2 + n + 53) (or any other polynomial)
and O(n) are considered equal performance.
O(1) and O(100000000000000) are also equal.

SNEAK PEEK INTO THE FUTURE:
So how do these memory and time requirements interact in the future.
Well trees are a pretty complicated data structure, usually when traversed
recursively, the memory usage is only as big as the depth of the tree. As
for the time usage, well its very specific to your use case, its best to
calculate it yourself. One commont thing to consider though is when working
with:

ORDERED VS UNORDERED LISTS:
Usually the best way to reduce performance of data operations on a list
is for the list itself to be ordered. The textbook gives an example of how
an action (append and intersect) can be taken from O(n^2) to O(n) which is a
massive improvement when the list is ordered.
