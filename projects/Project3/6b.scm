(define-class (food name calories)
  (parent (thing name))
  (instance-vars (edible? #t)) )

(define-class (bagel calories)
  (parent (food 'bagel calories))
  (class-vars (name 'bagel)) )

(define-class (flan calories)
  (parent (food 'flan calories))
  (class-vars (name 'flan)) )

(define-class (curry calories)
  (parent (food 'curry calories))
  (class-vars (name 'curry)) )

(define Alejandro (instantiate person 'Alejandro Noahs))
(define homemade-flan (instantiate flan 500))

(ask Noahs 'appear homemade-flan)
(ask Alejandro 'take homemade-flan)
