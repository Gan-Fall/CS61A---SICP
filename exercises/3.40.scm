;;1
;; (* x x)-->  100
;;            | | |
;;            v v v
;;         (* x x x)-->1000000 "Correct"

;;2
;;            (* x x)-------->1000000 "Correct"
;;               ^ ^
;;               | |
;; (* x x x)--> 1000

;;3
;; (*        x       x) -------->10*1000=10000
;;           ^       ^
;;          10       |
;;      (* x x x)->1000

;;4
;; (* x x) ------->100
;;              10 |
;;             v v v
;;          (* x x x)->10000

;;5
;; (* x x) ----->100
;;            10 | |
;;             v v v
;;          (* x x x)->100000

;;Race conditions
;;6
;; (* x x) --------------------------------------> set! x 100 ;final value
;;          (* x x x)-> set! x 1000

;;7
;;           (* x x) -> set! x 100
;; (* x x x)-----------------------> set! x 1000 ;final value
