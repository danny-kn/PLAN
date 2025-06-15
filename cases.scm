; test cases:
(define c1 '(planProg 10))
(define c2 '(planProg (planAdd 1 2)))
(define c3 '(planProg (planMul 2 5)))
(define c4 '(planProg (planSub 0 10)))
(define c5 '(planProg (planIf 0 5 10)))
(define c6 '(planProg (planLet x 10 (planAdd x x))))
(define c7 '(planProg (planAdd 10 (planLet x 5 (planMul x x)))))
(define c8 '(planProg (planLet x (planSub 0 (planLet x 10 x)) (planAdd x (planLet x 1 (planAdd x x))))))
(define c9 '(planProg (planLet x (planSub 0 (planAdd 10 11)) (planLet y x (planMul x y)))))
(define c10 '(planProg (planIf (planAdd 0 1) (planLet x 10 x) (planLet x 15 x))))

(define e1 10)
(define e2 3)
(define e3 10)
(define e4 -10)
(define e5 10)
(define e6 20)
(define e7 35)
(define e8 -8)
(define e9 441)
(define e10 10)

; additional test cases:
(define c11 '(planProg 5))
(define c12 '(planProg (planAdd (planAdd 7 (planIf (planMul 4 5) 0 10)) (planMul 2 5))))
(define c13 '(planProg (planLet z (planAdd 4 5) (planMul z 2))))
(define c14 '(planProg (planLet a 66 (planAdd (planLet b (planMul 2 4) (planAdd 2 b)) (planMul 2 a)))))
(define c15 '(planProg (planLet x 66 (planAdd (planLet x (planMul 2 4) (planAdd 2 x)) (planMul 2 x)))))

(define e11 5)
(define e12 17)
(define e13 18)
(define e14 142)
(define e15 142)

; extra credit test cases:
(define c16 '(planProg (planLet a (planFunction b (planAdd b b)) (a 5))))
(define c17 '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a 1 (planMul a a)))))

(define e16 10)
(define e17 1)

; ---
(define c18 '(planProg (planLet a (planFunction b (planAdd b b)) (a 5))))
(define c19 '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a 1 (planMul a a)))))
(define c20 '(planProg (planLet a (planFunction b (planAdd b b)) (planAdd (a 5) (a 5)))))
(define c21 '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a (planFunction b (planMul b b)) (a 5)))))

(define e18 10)
(define e19 1)
(define e20 20)
(define e21 25)

; another test case:
(define c22 '(planProg (planLet a (planFunction b (planLet x 100 x)) (planAdd (a 5) (a 6)))))

(define e22 200)

(define (test x)
	(load "myfns.scm")
	(display
		(string-append
			"Expected:\n"
			(number->string
				(eval
					(string->symbol
						(string-append
							"e"
							(number->string x)
						)
					)
					(interaction-environment)
				)
			)
			"\nYour output:\n"
		)
	)
	(plan
		(eval
			(string->symbol (string-append "c" (number->string x)))
			(interaction-environment)
		)
	)
)
