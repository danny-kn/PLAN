; https://www.s48.org/
; main src: https://www.cs.utexas.edu/ftp/garbage/cs345/schintro-v14/schintro_toc.html

; start the interpreter.
; note: imported from piazza.
(define (plan program)
	(evalPlanExpr (cadr program) '())
)

; evaluate the expression.
; note: imported from piazza with modifications
; to handle the remaining non-terminal symbols.
(define (evalPlanExpr expr bindings)
	(cond
		((integer? expr) expr)
		((symbol? expr) (lookup expr bindings))

		((equal? (car expr) 'planIf) (evalPlanIf expr bindings))
		((equal? (car expr) 'planAdd) (evalPlanAdd expr bindings))
		((equal? (car expr) 'planMul) (evalPlanMul expr bindings))
		((equal? (car expr) 'planSub) (evalPlanSub expr bindings))
		((equal? (car expr) 'planLet) (evalPlanLet expr bindings))
		((symbol? (car expr)) (evalPlanFunc expr bindings))
	)
)

; eval. the first expr.
; if the result is a positive integer, eval. the second expr. and return the value.
; if the result is a negative whole number, eval. the third expr. and return the value.
(define (evalPlanIf expr bindings)
	; src: https://stackoverflow.com/questions/58640785/how-to-use-the-if-statement-in-scheme-programming
	(cond
		((> (evalPlanExpr (cadr expr) bindings) 0) (evalPlanExpr (caddr expr) bindings))
		(else (evalPlanExpr (cadddr expr) bindings))
	)
)

; eval. the sum of the vals. of the two expressions.
(define (evalPlanAdd expr bindings)
	( +
		(evalPlanExpr (cadr expr) bindings) ; (car (cdr expr))
		(evalPlanExpr (caddr expr) bindings) ; (car (cdr (cdr expr)))
	)
)

; eval. the product of the vals. of the two expressions.
(define (evalPlanMul expr bindings)
	( *
		(evalPlanExpr (car (cdr expr)) bindings)
		(evalPlanExpr (car (cdr (cdr expr))) bindings)
	)
)

; eval. the difference of the vals. of the two expressions.
(define (evalPlanSub expr bindings)
	( -
		(evalPlanExpr (car (cdr expr)) bindings)
		(evalPlanExpr (car (cdr (cdr expr))) bindings)
	)
)

; first, bind the result of evaluating the first expression to the identifier.
; then, use the binding while evaluating the second expression.
; note: bindings is a list of symbol-value pairs.
; (define (evalPlanLet expr bindings)
; 	(evalPlanExpr (cadddr expr)
; 		(cons (cons (cadr expr)
; 			(evalPlanExpr (caddr expr) bindings)) bindings)
; 	)
; )

(define (evalPlanLet expr bindings)
    (cond
        ((and (pair? (caddr expr)) (equal? (car (caddr expr)) 'planFunction))
            (evalPlanExpr (cadddr expr)
                (cons (cons (cadr expr)
                            (caddr expr))
                      bindings)))
        (else
            (evalPlanExpr (cadddr expr)
                (cons (cons (cadr expr)
                            (evalPlanExpr (caddr expr) bindings))
                      bindings)))))

; this func. returns the val. associated with the identifier.
; note: bindings is a list of symbol-value pairs.
(define (lookup identifier bindings)
	(cond
		;; ((equal? identifier (car (car bindings))) (cdr (car bindings)))
		((equal? identifier (caar bindings)) (cdar bindings))
		(else (lookup identifier (cdr bindings)))
	)
)

(define (evalPlanFunc expr bindings)
    (evalPlanExpr
        (caddr (lookup (car expr) bindings))
        (cons
            (cons
                (cadr (lookup (car expr) bindings))
                (evalPlanExpr (cadr expr) bindings))
            bindings)))
