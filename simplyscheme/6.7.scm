(define (type-of arg)
  (cond ((boolean? arg) 'boolean)
	((number? arg) 'number)
	((word? arg) 'word)
	((sentence? arg) 'sentence)
	(else '(No Clue))))
