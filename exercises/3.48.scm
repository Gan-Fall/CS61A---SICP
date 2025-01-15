;; Yes, this will work because assuming the account numbers are unique,
;; the lower number will always be acquired. So if you have p1 trying to swap
;; a and b, and p2 trying to swap b and a, instead of p1 locking a and and p2
;; locking b and both waiting forever for the other to be unlocked/released,
;; you now have both starting on the a mutex, therefore following the same
;; order.

;; Account numbering should also be serialized or two accounts could get the
;; same number.
