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

(define Alejandro (instantiate person 'Alejandro Telegraph-Ave))
(define homemade-flan (instantiate flan 500))
(define jail (instantiate place 'jail))

(ask Telegraph-Ave 'appear homemade-flan)
(ask Alejandro 'take homemade-flan)

(define Police-PatrolA (instantiate police 'PatrolA Telegraph-Ave))
(define Police-PatrolB (instantiate police 'PatrolB Pimentel))

(ask Alejandro 'go 'north)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TRANSCRIPT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;ganfall@Hades ~/github/CS61A---SICP $ stklos
;;  \    STklos version 2.10 (stable)
;;   \   Copyright (C) 1999-2024 Erick Gallesio <eg@stklos.net>
;;  / \  [Linux-6.12.8-gentoo-dist-x86_64/none/readline/utf8]
;; /   \ Type ',h' for help
;;stklos> (load "simply.scm")
;;stklos> (load "libraries/obj.scm")
;;stklos> (load "projects/Project3/adv.scm")
;;stklos> (load "projects/Project3/tables.scm")
;;stklos> (load "projects/Project3/adv-world.scm")
;;stklos> (load "projects/Project3/7b.scm")
;;There are tie-dyed shirts as far as you can see...

;;Alejandro took flan

;;There are tie-dyed shirts as far as you can see...


;;Alejandro moved from Telegraph-Ave to Sproul-Plaza

;;nasty took flan


;;nasty moved from Sproul-Plaza to Pimentel
;;Crime Does Not Pay

;;PatrolB took flan


;;nasty moved from Pimentel to jail
