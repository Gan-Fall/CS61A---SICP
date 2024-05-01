(define (vowel? char)
  (member? char 'aeiou))

(define (indef-article wd)
  (if (vowel? (first wd)) (se 'an wd) (se 'a wd)))
