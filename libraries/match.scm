;;MATCH.SCM                                            Nov. 1, 2000


;;;;                            MATCHING


;   For the MATCH procedure below, identifiers of the form
;                                    ?<name>
;   match one datum, identifiers of the form
;                                   ~<name>
;   match a sequence of consecutive data items within a list, and a
;   "context pattern"
;                              ($<name> <pattern>)
;   matches the "context" in which <pattern> is matched.  For example, the
;   pattern (?a ~b) can be matched against several subexpressions of the datum
;                            (1 (2 3 4) (5 (2 3 4))).

;   One such subexpression is (2 3 4), where ?a must match 2 and ~b
;   matches (3 4).  But notice there are TWO occurrences of the
;   subexpression (2 3 4): it occurs after the 1 and also occurs after the 5.
;   In general, the location of an occurrence can be exactly specified
;   by describing the CONTEXT of the occurrence, namely the remainder of the
;   expression after the occurrence is replaced by a special marker, <>,
;   called the HOLE.  So the first occurrence of (2 3 4) is in the context
;                            (1 <> (5 (2 3 4)))
;   and the second occurrence is in the context
;                            (1 (2 3 4) (5 <>)).
;   In fact the pattern (?a ~b) can match the datum above in four different
;   ways, which can be found by evaluating
;                (match '($C (?a ~b)) '(1 (2 3 4) (5 (2 3 4)))).
;   This call to MATCH returns the following list of four association lists
;   called DICTIONARIES, where each dictionary indicates the context of a match,
;   the subexpression matched by ?a, and the subexpression matched by ~b:
;      ((($c <>) (?a 1) (~b ((2 3 4) (5 (2 3 4)))))
;       (($c (1 <> (5 (2 3 4)))) (?a 2) (~b (3 4)))
;       (($c (1 (2 3 4) <>)) (?a 5) (~b ((2 3 4))))
;       (($c (1 (2 3 4) (5 <>))) (?a 2) (~b (3 4)))).

;   Variables with % as their second character have an associated
;   "restriction-predicate" -- a procedure to test if the variable is allowed
;   to match a value.  For example, the variable ?%num can only match a number
;   because its associated restriction-predicate is NUMBER? .


;;The following Scheme procedure definitions serve as an EXECUTABLE
;;MATHEMATICAL SPECIFICATION of pattern matching.  That is, they are a
;;fairly direct translation into Scheme of the inductive definitions by
;;which matching would ordinarily be defined mathematically.  One of
;;Scheme's particular virtues is that it provides for such direct
;;translation.

;;The definitions of all the procedures needed in the actual matching
;;process are written in a small functional fragment of Scheme (a few
;;side-effects are utilized only to control I/O).  The code aims to be
;;elementary, mathematically precise, easy to understand, and
;;easy to verify.  To achieve this, various optimizations, obvious and
;;subtle, have been eschewed wherever they required a compromise in
;;simplicity.  Nevertheless, the matching procedures below can still
;;usefully be run -- though when a pedagogical Scheme "substitution
;;model" interpreter based on term rewriting, for example, is implemented
;;with them, the resulting interpreter runs about 10^6 times slower than
;;a standard interpreter.


;;Set the variable HIDE-RULE-APPLICATION? to #f to display the progress
;;of rule applications.

(define hide-rule-application? #f)




;   The call (MATCH PATTERN DATUM) returns a list of dictionaries for all
;   possible matches of PATTERN against DATUM.  It returns the empty list when
;   there is no match.
;   MATCH: (PATTERN, DATUM) --> LIST(DICTIONARY)

(define (match pat dat)
  (cond ((exact-match? pat)
         (if (equal? pat dat)
             (list the-empty-dictionary) ;EXACT MATCH
             '()))                       ;NO MATCH
        ((qmark-variable? pat)
         (match-qmark-variable pat dat))
        ((initial-tilde-variable? pat)
         (match-initial-tildevar (car pat) (cdr pat) dat))
        ((context-pattern? pat)
         (match-cpat (context-pattern.var pat)
                     (context-pattern.pattern pat)
                     dat))
        ((pair? pat)
         (match-pair-pat (car pat) (cdr pat) dat))
        (else (error "MATCH: unknown pattern" pat))))


(define (exact-match? pat)
  (or (null? pat)
      (and (atom? pat)
           (not (match-variable? pat)))))

(define (atom? pat)
  (and (not (null? pat))                ;needed when NIL = #f as in MIT Scheme
       (or (number? pat)
           (boolean? pat)
           (string? pat)
           (symbol? pat))))

(define (match-qmark-variable qvar dat)
  (if ((restriction-predicate qvar) dat) ;check that any restriction is met
      (list (make-dictionary `((,qvar ,dat))))
      '()))                             ;NO MATCH


(define (match-initial-tildevar tilde-var rest-pat dat)
  (cond
   ((atom? dat) '())      ;NO MATCH: an initial tilde-var pattern only matches lists
   ((list? dat)
    (append-map   ;TILDE-VAR must match a prefix of DAT and
                  ;REST-PAT must match the remaining suffix.
     (lambda (pref suf)
           ;each element in the list bound to TILDE-VAR must obey the restriction:
       (if (for-all? pref (restriction-predicate tilde-var))
           (filter not-fail?
                   (map (make-dictionary-extender tilde-var pref)
                        (match rest-pat suf)))
           '()))
     (prefixes dat)
     (suffixes dat)))
   (else (error "MATCH-INITIAL-TILDEVAR: unknown datum" dat))))    ;NO MATCH


;;; (prefixes '(1 2 3)) ==> (() (1) (1 2) (1 2 3))
;;; (suffixes '(1 2 3)) ==> ((123) (23) (3) ())

(define (prefixes l)
  (if (pair? l)
      (let ((first-l (car l)))
        (cons '()
              (map
               (lambda (suff) (cons first-l suff))
               (prefixes (cdr l)))))
      '(())))

(define (suffixes l)
  (if (pair? l)
      (cons l (suffixes (cdr l)))
      '(())))


                        ;;ORDINARY CONTEXT PATTERNS

;;MATCH-CPAT IS EASY TO FOLLOW FOR THE NAMELESS CVAR, $, because we can
;skip variable restrictions and calculation of the CVAR's context-value:

;(define (match-nameless-cvar hole-pat datum)
;  (append
;                            ;match HOLE-PAT against all of DAT
;   (match hole-pat dat)
;                            ;match the context pattern against each subtree of DAT
;   (append-map
;    (match-nameless-cvar hole-pat dat))))

;Here's the general case:

(define (match-cpat cvar hole-pat datum)
  (define (match-cpat-in-context dat cntxt)
    (append
                            ;match HOLE-PAT against all of DAT
                            ;binding CVAR to CNTXT
     (if ((restriction-predicate cvar) cntxt)
         (map (make-dictionary-extender cvar cntxt)
              (match hole-pat dat))
         '())

     (if (pair? dat)
                            ;match the context pattern against each subtree of DAT
                            ;binding CVAR to the enlarged context of each match
                            ;The hole of the context of the matches is enlarged
                            ;with the prefixes and suffixes of the datum.
         (append-map
           (lambda (left-trees subtree right-trees)
             (match-cpat-in-context
              subtree
              (insert-into-hole
               cntxt
               `(,@left-trees ,hole ,@right-trees))))
           (except-last-pair (prefixes dat))
           dat
           (suffixes (cdr dat)))
         '())))
  (match-cpat-in-context datum hole))


(define (insert-into-hole context datum)
  (define (try dat)         ;look for HOLE in DAT and replace with DATUM,
                            ;FAIL if no HOLE found.
    (cond ((hole? dat) datum)
          ((or (null? dat)
               (atom? dat))
           (fail))          ;no HOLE
          ((pair? dat)
           (let ((result (try (car dat))))
             (if (fail? result)
                 (let ((other-result (try (cdr dat))))  ;no HOLE in (car DAT)
                   (if (fail? other-result)
                       (fail)                      ;also no HOLE in (cdr DAT)
                       (cons (car dat) other-result))) ;found HOLE in (cdr DAT)
                 (cons result (cdr dat)))))            ;found HOLE in (car DAT)
          (else (error "INSERT-INTO-HOLE: unknown context" dat))))
  (try context))


(define (match-pair-pat pat1 pat2 dat)
  (if (pair? dat)
      (let ((dicts1 (match pat1 (car dat))))
        (if (pair? dicts1)
            (product-merge-dicts
             dicts1
             (match pat2 (cdr dat)))
            '()))
      '()))                 ;NO MATCH: DAT is not a pair


;MATCH?: (PATTERN, DATUM) --> BOOL
(define (match? pat dat)
  (pair? (match pat dat)))


;;                     INSTANTIATION

;A TEMPLATE is a PATTERN

;INSTANTIATE: (TEMPLATE, DICTIONARY) --> DATUM


(define (instantiate templ dict)
;                 Variables in TEMPL must be associated with values in DICT
  (cond ((exact-match? templ) templ)
        ((qmark-variable? templ) (lookup templ dict))
        ((context-pattern? templ)
         (let ((cntxt (lookup (context-pattern.var templ) dict))
               (hole-datum
                (instantiate
                 (context-pattern.pattern templ)
                 dict)))
           (insert-into-hole cntxt hole-datum)))
        ((initial-tilde-variable? templ)
         (append (lookup (car templ) dict)
                 (instantiate (cdr templ) dict)))
        ((pair? templ)
         (cons (instantiate (car templ) dict)
               (instantiate (cdr templ) dict)))
        (else (error "INSTANTIATE: unknown template" templ))))



       ;;VARIABLES

(define (match-variable? pat)
  (or (qmark-variable? pat)
      (tilde-variable? pat)
      (context-variable? pat)))

(define (qmark-variable? p)
  (and (symbol? p)
       (char=? #\? (string-ref (symbol->string p) 0))))
         
(define (tilde-variable? p)
  (and (symbol? p)
       (char=? #\~ (string-ref (symbol->string p) 0))))

(define (nameless? var)
  (or (nameless-qmark? var)
      (nameless-tilde? var)
      (nameless-cvar? var)))

(define (nameless-qmark? p)
  (or (eq? p '?) (eq? p '?%)))

(define (nameless-tilde? p)
  (or (eq? p '~) (eq? p '~%)))

(define (nameless-cvar? p)
  (or (eq? p '$) (eq? p '$%)))

(define (context-variable? p)
  (and (symbol? p)
       (char=? #\$ (string-ref (symbol->string p) 0))))

(define (initial-tilde-variable? pat)
  (and (pair? pat) (tilde-variable? (car pat))))

(define (match-variables-of pattern)
  (graph-search
   (lambda (node) (cons node node))
   (list pattern) match-variable?))

(define (restriction-predicate var)
  (let ((str (symbol->string var)))
    (if (and (> (string-length str) 1)
             (char=? #\% (string-ref str 1)))
        (let ((binding (assq var restriction-table)))
          (if binding
              (cadr binding)
              (error "RESTRICTION-PREDICATE: no entry for" var)))
        constant-true-function)))

(define restriction-table '())

(define (constant-true-function datum) #t)



                         ;;CONTEXT PATTERNS

(define hole '<>)

(define (hole? thing)
  (eq? hole thing))

(define (context-pattern? pat)
  (and (pair? pat)
       (context-variable? (car pat))))

(define context-pattern.var car)
(define context-pattern.pattern cadr)



                             ;;DICTIONARIES

(define the-empty-dictionary '(empty-dict))

(define (empty-dictionary? dict)
  (eq? dict the-empty-dictionary))

(define (make-dictionary-extender var val)
        ;ADD BINDING (VAR VAL) IF CONSISTENT, ELSE FAIL
  (lambda (dict)
    (cond ((nameless? var) dict)
          ((empty-dictionary? dict)
           `((,var ,val)))
          (else
           (let ((bind (assq var dict)))
            (if bind
                (if (equal? val (cadr bind))
                    dict                ; nothing to do: (var val) already in dict
                    (fail))             ; inconsistent bindings for var
                (cons `(,var ,val) dict))))))) ; add binding (var val)

(define (make-dictionary bindings)
  (if (pair? bindings)
      ((make-dictionary-extender (caar bindings) (cadar bindings))
       (make-dictionary (cdr bindings)))
      the-empty-dictionary))
                            

(define (lookup var dict)
  (if (empty-dictionary? dict)
      (error "LOOKUP in empty dict" var)
      (let ((bind (assq var dict)))
        (if bind
            (cadr bind)
            (error "LOOKUP: missing variable" var dict)))))


;MERGE-DICTS: (DICTIONARY, DICTIONARY) --> (DICTIONARY + FAIL)
(define (merge-dicts dict1 dict2) 
  (define (try binds dict)
    (cond ((fail? dict) (fail))
          ((pair? binds)
           (try (cdr binds) ((make-dictionary-extender
                              (caar binds) (cadar binds))
                             dict)))
          (else dict)))
  (if (empty-dictionary? dict1)
      dict2
      (try dict1 dict2)))


;PRODUCT-MERGE-DICTS: RETURNS ALL POSSIBLE PAIRWISE MERGES

(define (product-merge-dicts dicts1 dicts2)
  (filter not-fail? 
          (all-pairs dicts1 dicts2 merge-dicts)))

;  (all-pairs '(x1 ... xn) '(y1 ... ym) op) =
;       (list
;         (op x1 y1) (op x1 y2) ... (op x1 ym)   --|
;                             .                    |
;                             .                    |  ONE BIG LIST
;                             .                    |
;         (op xn y1) (op xn y2) ... (op xn ym))  --|


;(tensor '(x1 ... xn) '(y1 ... ym) op) =
;   (list
;     (list (op x1 y1) (op x1 y2) ... (op x1 ym))  --|
;                         .                          |
;                         .                          |List of Lists
;                         .                          |
;     (list (op xn y1) (op xn y2) ... (op xn ym))) --|


(define (tensor x-list y-list op)
    (map (lambda (x)
           (map (lambda (y) (op x y))
                y-list))
         x-list))


(define (all-pairs x-list y-list op)
  (apply append (tensor x-list y-list op)))


;;                             RULES


;MAKE-SIMPLE-RULE: (PATTERN, TEMPLATE) --> SIMPLE-RULE
(define make-simple-rule list)
(define simple-rule.pattern car)
(define simple-rule.template cadr)
(define (simple-rule? rule)
  (and (pair? rule)
       (not (eq? gen-rule-tag (car rule)))))

;GENERAL RULES

;MAKE-GENERAL-RULE: (PATTERN, PROCEDURE) --> GENERAL-RULE
(define (make-general-rule pattern proc)
  (list gen-rule-tag pattern
        (make-dict-proc proc (match-variables-of pattern))))

;The PROCEDURE part of the argument to MAKE-GENERAL-RULE expects as
;arguments values for the match-variables in PATTERN.  The PROCEDURE
;returns the result of the rule, namely, a DATUM or FAIL.  So
;             PROCEDURE: DATUM^n --> (DATUM + FAIL)
;where n is the number of match-variables in PATTERN.

;EXAMPLES
;(define rule:+ (make-general-rule '(+ ?%val1 ?%val2) +))

;(define rule:bubble-sort
;  (make-general-rule
;   '(~a ?%num1 ?%num2 ~b)
;   (lambda (a n1 n2 b)
;      (if (<= n2 n1)
;          `(,@a ,n2 ,n1 ,@b)
;          (fail))))


(define (general-rule? rule)
  (and (pair? rule)
       (eq? (car rule) gen-rule-tag)))
(define general-rule.pattern cadr)
(define general-rule.proc caddr)
(define gen-rule-tag (list 'general-rule))



;MAKE-DICT-PROC converts a procedure expecting values into a procedure
;expecting a dictionary containing the values.  There is a LOOKUP error if
;the procedure made by (MAKE-DICT-PROC PROC VARS) is applied to a dictionary
;which does not associate values with all of VARS.

;MAKE-DICT-PROC: (PROCEDURE, LIST(VARIABLES)) --> [DICT --> (DATUM + FAIL)]
(define (make-dict-proc proc vars)
  (lambda (dict)
    (apply
     proc
     (map (lambda (var) (lookup var dict))
          vars))))


;USE-ANYWHERE: RULE --> RULE
;returns a version of the rule which may be applied to any subexpression

(define (use-anywhere rule)
  (cond ((simple-rule? rule) (use-simple-rule-anywhere rule))
        ((general-rule? rule) (use-general-rule-anywhere rule))
        (else (error "USE-ANYWHERE: unknown rule type" rule))))

(define (use-simple-rule-anywhere srule)
  (let ((cvar (get-cleaned-variable '$C (match-variables-of srule))))
    (make-simple-rule `(,cvar ,(simple-rule.pattern srule))
                      `(,cvar ,(simple-rule.template srule)))))

;EXAMPLE:
;(define rule:cntxt+
;  (make-simple-rule
;   '(($C ?arithmetic-expr1) + ($C ?arithmetic-expr2))
;   '(($C 0) + ($C (?arithmetic-expr1 + ?arithmetic-expr2)))))

;(pp (use-anywhere rule:cntxt+))
;;(($c_0 (($c ?arithmetic-expr1) + ($c ?arithmetic-expr2)))
;; ($c_0 (($c 0) + ($c (?arithmetic-expr1 + ?arithmetic-expr2)))))


(define (use-general-rule-anywhere grule)
  (let ((cvar (get-cleaned-variable '$C (match-variables-of grule))))
    (list
     gen-rule-tag
                      ;PATTERN for the ANYWHERE VERSION:
     `(,cvar ,(general-rule.pattern grule))
                      ;PROC for the ANYWHERE VERSION:
     (lambda (dict)
       (let ((result ((general-rule.proc grule) dict)))
         (if (fail? result)
             (fail)
             (insert-into-hole
              (lookup cvar dict) result)))))))

          
                    ;ONE APPLICATION and ONE FINAL FORM


;ONE-RULE-APPLICATION: (RULE, DATUM) --> (DATUM + FAIL)
(define (one-rule-application rule datum)
  ((cond ((simple-rule? rule)
          one-simple-rule-application)
         ((general-rule? rule)
          one-general-rule-application)
         (else (error "ONE-RULE-APPLICATION: unknown rule type" rule)))
   rule datum))

(define (one-simple-rule-application srule datum)
  (let ((dicts (match (simple-rule.pattern srule) datum)))
    (if (pair? dicts)
        (instantiate (simple-rule.template srule) (car dicts))
        (fail))))

(define (one-general-rule-application grule datum)
  (let ((proc (general-rule.proc grule)))
    (define (try rest-dicts)
      (if (pair? rest-dicts)
          (let ((result (proc (car rest-dicts))))
            (if (fail? result)
                (try (cdr rest-dicts))
                result))
          (fail)))
    (try (match (general-rule.pattern grule) datum))))



;ONE-RULES-APPLICATION: (LIST(RULE), DATUM) --> (DATUM + FAIL)
(define (one-rules-application rules datum)
  (define (try rest-rules)
    (if (pair? rest-rules)
        (let ((result (one-rule-application (car rest-rules) datum)))
          (if (fail? result)
              (try (cdr rest-rules))
              result))
        (fail)))
  (try rules))


;ONE-FINAL-FORM: LIST(RULE) --> DATUM
(define (one-final-form rules datum)
  (define (try dat)
    (let ((new-datum (one-rules-application rules dat)))
      (if (fail? new-datum)
          dat
          (begin
            (or hide-rule-application?
                (begin (newline) (pretty-print new-datum)))
            (try new-datum)))))
  (try datum))


;ONE-EVERYWHERE-FINAL-FORM: LIST(RULE) --> DATUM
;like ONE-FINAL-FORM but uses rules everywhere
(define (one-everywhere-final-form rules datum)
  (one-final-form (map use-anywhere rules) datum))


;The ONE-EVERYWHERE-FINAL-FORM procedure straightforwardly reflects the
;specification of "an everywhere final form," namely, a datum such that no
;rule applies to the datum itself or any of subdatum of it.  However, while
;ONE-EVERYWHERE-FINAL-FORM is correct and simple, it is often extremely
;inefficient, and should be avoided when possible.

;A useful property of some sets of rewrite rules is that everywhere final forms
;can be found by applying rules "top down."  Namely, the rules have the
;property that rewriting a SUBexpression of an expression will never cause
;any additional rule to be applicable to the whole expression.  (For
;example, the desugaring rules for Scheme have this property.)  In that
;case, the procedure ONE-TOPDOWN-FINAL-FORM will correctly, and more
;efficiently, find an everywhere final form.

(define (one-topdown-final-form rules datum)
  (let ((top-result (one-final-form rules datum)))
    (if (list? top-result)
        (map
         (lambda (subdatum)
           (one-topdown-final-form rules subdatum))
         top-result)
        top-result)))

;Similarly, a set of rewrite rules may be "bottom up."  For example, the
;rules for simplifying zeroes and ones from products and sums are "bottom
;up" rules.

(define (one-bottomup-final-form rules datum)
  (let ((bottom-result
         (if (pair? datum)
             (map
              (lambda (subdatum)
                (one-bottomup-final-form rules subdatum))
              datum)
             datum)))
    (one-final-form rules bottom-result)))



                    ;ALL APPLICATIONS and ALL FINAL FORMS


;APPLY-RULE: (RULE, DATUM) --> LIST (DATUM)
(define (apply-rule rule datum)
  ((cond ((simple-rule? rule)
          apply-simple-rule)
         ((general-rule? rule)
          apply-general-rule)
         (else (error "APPLY-RULE: unknown rule type" rule)))
   rule datum))


;APPLY-SIMPLE-RULE: (SIMPLE-RULE, DATUM) --> LIST(DATUM)
(define (apply-simple-rule rule datum)
  (let ((template (simple-rule.template rule)))
    (map (lambda (dict) (instantiate template dict))
         (match (simple-rule.pattern rule) datum))))


;APPLY-GENERAL-RULE: (GENERAL-RULE, DATUM) --> LIST(DATUM)
(define (apply-general-rule rule datum)
  (filter not-fail?
          (map (general-rule.proc rule)
               (match (general-rule.pattern rule) datum))))

        
;APPLY-RULES: (LIST(RULE), DATUM) --> LIST (DATUM)
(define (apply-rules rules datum)
   (append-map (lambda (rule) (apply-rule rule datum)) rules))


(define (final-forms rules datum)
  (define (node-info node)
    (let ((nodes (apply-rules rules node)))
      (cons nodes nodes)))
  ((if hide-rule-application?
       graph-search
       show-graph-search)
   node-info (list datum) null?))


(define (everywhere-final-forms rules datum)
  (final-forms
   (map use-anywhere rules) datum))



                              ;;GRAPH SEARCH

;A labelled digraph is specified by a procedure
;              NODE-INFO: NODE --> (LIST(NODE) X LABEL)
;which takes a node, N, as argument and returns a pair consisting of
;    (1) list of the nodes adjacent to N, and
;    (2) the label of N.
;(GRAPH-SEARCH NODE-INFO NODES PRED?) returns a list of the nodes whose
;labels satisfy PRED? which are reachable by directed paths starting from
;any node in NODES. For example, we could define DISTINCT-LEAVES of a tree,
;or even a CIRCULAR list structure, as:
;(define (distinct-leaves list-structure)
;  (graph-search
;   (lambda (node) (cons node node))
;   (list list-structure)
;   (lambda (node) (not (or (pair? node) (null? node))))))


(define (graph-search node-info nodes pred?)
  (define (aux to-do done good)         ;TO-DO, DONE, GOOD are SETS of nodes
    (if (nonempty? to-do)
        (let ((node (select to-do)))
          (if (element-of? node done)
              (aux (delete node to-do) done good)
              (let* ((nhbrs&label (node-info node))
                     (neighbors (car nhbrs&label))
                     (label (cdr nhbrs&label)))
                (aux (adjoin-list neighbors (delete node to-do))
                     (adjoin node done)
                     (if (pred? label) (adjoin node good) good)))))
        good))
  (set->list
   (aux
    (adjoin-list nodes (emptyset))
    (emptyset)
    (emptyset))))


;SHOW-GRAPH-SEARCH is same as GRAPH-SEARCH except it displays search
;information as it searches.

(define (show-graph-search node-info nodes pred?)
  (let ((num-node-visits 0)
        (num-done 0)
        (num-good 0))
    (define (aux-show to-do done good)
      (newline)
      (display `(,num-node-visits ,num-done ,num-good))
      (newline)
      (if (nonempty? to-do)
          (let ((node (select to-do)))
            (set! num-node-visits (+ num-node-visits 1))
            (if (element-of? node done)
                (aux-show (delete node to-do) done good)
                (let* ((nhbrs&label (node-info node))
                       (neighbors (car nhbrs&label))
                       (label (cdr nhbrs&label)))
                  (set! num-done (+ num-done 1))
                  (aux-show (adjoin-list neighbors (delete node to-do))
                            (adjoin node done)
                            (if (pred? label)
                                (begin
                                  (set! num-good (+ num-good 1))
                                  (pretty-print `(GOODNODE: ,node))
                                  (newline)
                                  (adjoin node good))
                                good)))))
          good))
    (pretty-print '(number-of-node-visits number-of-distinct-nodes number-of-good))
    (newline)
    (set->list
     (aux-show
      (adjoin-list nodes (emptyset))
      (emptyset)
      (emptyset)))))

                                ;;SETS AS LISTS

(define (adjoin element set)
  (if (member element set)
      set
      (cons element set)))
(define (adjoin-list ls set)
  (if (pair? ls)
      (adjoin-list (cdr ls) (adjoin (car ls) set))
      set))
(define (emptyset) '())
(define nonempty? pair?)
(define element-of? member)
(define select car)
(define (delete obj ls)      ;remove first occurrence, if any, of OBJ from LS
  (if (pair? ls)
      (if (equal? obj (car ls))
          (cdr ls)
          (cons (car ls) (delete obj (cdr ls))))
      ls))
(define (set->list set) set)


                             ;;FAIL PROCEDURES


(define fail-value (list  "FAIL"))
(define (fail) fail-value)
(define (fail? datum)
  (equal? datum fail-value))     ;EQ? should work, but caused an unsolved problem
(define (not-fail? datum)
  (not (fail? datum)))


                                ;;UTILITIES


(define (append-map f . l)
  (apply append (apply map (cons f l))))


(define (filter p l)
  (cond ((null? l) '())
        ((p (car l))
         (cons (car l) (filter p (cdr l))))
        (else (filter p (cdr l)))))
      

(define (for-all? l p)
  (or (and (pair? l) (p (car l)) (for-all? (cdr l) p))
      (null? l)))


(define (except-last-pair ls)
  (define (aux first rest)
    (if (pair? rest)
        (cons first
              (aux (car rest) (cdr rest)))
        '()))
  (aux (car ls) (cdr ls)))


(define (last-pair ls)
  (define (aux first rest)
    (if (pair? rest)
        (aux (car rest) (cdr rest))
        (cons first rest)))
  (aux (car ls) (cdr ls)))


                         ;;FRESH SYMBOL GENERATION


;;GET-CLEANED-VARIABLE: (SYMBOL, LIST(SYMBOL)) --> SYMBOL
;(GET-CLEANED-VARIABLE SYMB VARS-TO-AVOID) returns a symbol which looks 
;like SYMB but with smallest possible natural number suffix, or no suffix,
;so it is NOT in VARS-TO-AVOID, e.g.,
;(get-cleaned-variable 'x_2 '(x y z_4 x_0))
;Value: x_1
;(get-cleaned-variable 'x_2 '(x_2 y z_4 x_0))
;Value: x


(define (get-cleaned-variable var vars-to-avoid)
  (let ((parsed-pairs-to-avoid
         (map parse-suffix vars-to-avoid))
        (var-string (car (parse-suffix var))))
    (define (try suffix)
      (if (member (cons var-string suffix) parsed-pairs-to-avoid)
          (try (+ 1 suffix))
          suffix))
    (if (member (cons var-string '()) parsed-pairs-to-avoid)
        (make-suffixed-symbol (cons var-string (try 0)))
        (string->symbol var-string))))


;PARSE-SUFFIX: SYMBOL --> (STRING X (NUMBER + NIL))
;(PARSE-SUFFIX SYMBOL) returns the pair (CONS NAME NUM) where NAME is the
;string-name of SYMBOL without its nonnegative integer suffix, and NUM is
;its integer suffix, or NIL if SYMBOL has no such suffix.
;; Examples:
;;   (parse-suffix 'x_4)  =  (cons (symbol->string 'x) 4)
;;   (parse-suffix 'x)    =  (cons (symbol->string 'x) '())
;;   (parse-suffix 'x_a)  =  (cons (symbol->string 'x_a) '())
;;   (parse-suffix 'x_-1) =  (cons (symbol->string 'x_-1) '())


(define (parse-suffix var)
  (let* ((var-string (symbol->string var))
         (lngth (string-length var-string)))
    (define (get-suffix-index n)
      (let ((next-char (string-ref var-string n)))
        (cond ((char-numeric? next-char)
               (get-suffix-index (- n 1)))
              ((char=? next-char #\_)   ;is NEXT-CHAR = "_"?
               (+ 1 n))                 ;index in string of beginning of suffix
              (else lngth))))
    (let ((index (get-suffix-index (- lngth 1))))
      (if (= index lngth)
          (cons var-string '())
          (cons
           (substring var-string 0 (- index 1)) ;NAME
           (string->number (substring var-string index lngth))))))) ;NUM

;;MAKE-SUFFIXED-SYMBOL: (STRING X (NUMBER + NIL)) --> SYMBOL
;;undoes PARSE-SUFFIX, namely,
;;            (MAKE-SUFFIXED-SYMBOL (PARSE-SUFFIX 'x_3)) = 'x_3


(define (make-suffixed-symbol string&suffix)
  (if (null? (cdr string&suffix))
      (string->symbol (car string&suffix))
      (string->symbol 
       (string-append 
        (car string&suffix)
        "_" 
        (number->string (cdr string&suffix))))))




;;                                SOME TYPES

;LIST(A)          =  NULL + [A X LIST(A)]
;TREE(A)          =  A + LIST(TREE(A))

;ATOM             =  SYMBOL + NUMBER + BOOLEAN + STRING
           
;DATUM            =  TREE(ATOM)

;CONTEXT          =  DATUM with only one occurrence of HOLE
;HOLE             =  the symbol '<>

;QMARK-VARIABLE   =  Symbol starting with "?"
;TILDE-VARIABLE   =  Symbol starting with "~"
;CONTEXT-VARIABLE =  Symbol starting with "$"

;ATOM-NO-TLCNV    =  ATOM  excluding TILDE-VARIABLE and CONTEXT-VARIABLE
;ATOM-NO-CNV      =  ATOM  excluding CONTEXT-VARIABLE

;PATTERN          =  ATOM-NO-TLCNV +
;                    (LIST(TREE(ATOM-NO-CNV + CONTEXT-PATTERN)))

;CONTEXT-PATTERN  =  CONTEXT-VARIABLE  X  PATTERN
;TEMPLATE         =  PATTERN           (ERROR if PATTERN contains a Nameless Variable)

;abstractly:
;DICTIONARY       =~ QMARK-VARIABLE   --> DATUM         X
;                    TILDE-VARIABLE   --> LIST(DATUM)   X
;                    CONTEXT-VARIABLE --> CONTEXT
;representation:
;DICTIONARY subset  LIST((QMARK-VARIABLE X DATUM) + 
;                   LIST(TILDE-VARIABLE  X LIST(DATUM) +
;                   LIST(CONTEXT-VARIABLE X CONTEXT)


;RULE             =  SIMPLE-RULE + GENERAL-RULE

;SIMPLE-RULE =    =  PATTERN X TEMPLATE
;                        (ERROR unless Vars(TEMPLATE) subset Vars(PATTERN))

;GENERAL-RULE     =  PATTERN X [DICTIONARY --> (DATUM + FAIL)]
;                        (ERROR unless Vars(PATTERN) subset dom(DICTIONARY))
