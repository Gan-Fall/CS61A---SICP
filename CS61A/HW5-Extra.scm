;Representing Huffman trees

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) 
                (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

;Decoding tree

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch 
                (car bits) 
                current-branch)))
          (if (leaf? next-branch)
              (cons 
               (symbol-leaf next-branch)
               (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) 
                        next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: 
               CHOOSE-BRANCH" bit))))

;Sets of weighted elements

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) 
         (cons x set))
        (else 
         (cons (car set)
               (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set 
         (make-leaf (car pair)    ; symbol
                    (cadr pair))  ; frequency
         (make-leaf-set (cdr pairs))))))

;2.67

(define sample-tree
  (make-code-tree 
   (make-leaf 'A 4)
   (make-code-tree
    (make-leaf 'B 2)
    (make-code-tree 
     (make-leaf 'D 1)
     (make-leaf 'C 1)))))

(define sample-message 
  '(0 1 1 0 0 1 0 1 0 1 1 1 0))

;2.68

(define (encode message tree)
  (if (null? message)
      '()
      (append 
       (encode-symbol (car message) 
                      tree)
       (encode (cdr message) tree))))

(define (encode-symbol wd tree)
  (cond ((not (member? wd (symbols tree))) (error "Symbol is not a member of tree"))
        ((and (leaf? (left-branch tree)) (eq? wd (symbol-leaf (left-branch tree)))) (list 0))
        ((and (leaf? (right-branch tree)) (eq? wd (symbol-leaf (right-branch tree)))) (list 1))
        ((and (not (leaf? (left-branch tree))) (member? wd (symbols (left-branch tree)))) (append (list 0) (encode-symbol wd (left-branch tree))))
        ((and (not (leaf? (right-branch tree))) (member? wd (symbols (right-branch tree)))) (append (list 1) (encode-symbol wd (right-branch tree))))))

;improved
(define (encode-symbol wd tree)
  (if (leaf? tree)
    (if (equal? (symbol-leaf tree) wd)
      '()
      (error "Symbol not in tree"))
    (if (member? wd (symbols (left-branch tree)))
      (cons 0 (encode-symbol wd (left-branch tree)))
      (cons 1 (encode-symbol wd (right-branch tree))))))

;2.69

(define (generate-huffman-tree pairs)
  (successive-merge 
   (make-leaf-set pairs)))

(define (successive-merge leaves)
  (if (null? (cdr leaves))
    (car leaves)
    (successive-merge
      (adjoin-set
        (make-code-tree (car leaves) (cadr leaves))
                        (cddr leaves))) ))

;2.70

(define lyric-tree
  (generate-huffman-tree
    '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1)) ))

(define get-a-job '(GET A JOB
SHA NA NA NA NA NA NA NA NA

GET A JOB
SHA NA NA NA NA NA NA NA NA

WAH YIP YIP YIP YIP 
YIP YIP YIP YIP YIP
SHA BOOM))
