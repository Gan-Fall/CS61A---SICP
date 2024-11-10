(define-class (miss-manners object)
              (method (please message . argument)
                      (ask object message arguments) ))
