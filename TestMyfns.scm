#!/usr/bin/env scheme-srfi-7

(program
  (requires srfi-34 srfi-78)
  (files "myfns.scm")
  (code

(define myinterpreter-with-exception-handling
  (lambda (progs)
    (call-with-current-continuation
      (lambda (k)
        (with-exception-handler
          (lambda (x)
            (display x)
            (newline)
            (k "Error")
			(newline))
          (lambda () (plan progs)))))))

(define (main args)
  (check-set-mode! 'report-failed)
  (display "Grading myfns.ss")
  (newline)

  ; test cases:
	(check (myinterpreter-with-exception-handling ; 1
           '(planProg 10))
         => 10)

	(check (myinterpreter-with-exception-handling ; 2
           '(planProg (planAdd 1 2)))
         => 3)

	(check (myinterpreter-with-exception-handling ; 3
           '(planProg (planMul 2 5)))
         => 10)

	(check (myinterpreter-with-exception-handling ; 4
           '(planProg (planSub 0 10)))
         => -10)

	(check (myinterpreter-with-exception-handling ; 5
           '(planProg (planIf 0 5 10)))
         => 10)

	(check (myinterpreter-with-exception-handling ; 6
           '(planProg (planLet x 10 (planAdd x x))))
         => 20)

	(check (myinterpreter-with-exception-handling ; 7
           '(planProg (planAdd 10 (planLet x 5 (planMul x x)))))
         => 35)

	(check (myinterpreter-with-exception-handling ; 8
           '(planProg (planLet x (planSub 0 (planLet x 10 x)) (planAdd x (planLet x 1 (planAdd x x))))))
         => -8)

	(check (myinterpreter-with-exception-handling ; 9
           '(planProg (planLet x (planSub 0 (planAdd 10 11)) (planLet y x (planMul x y)))))
         => 441)

	(check (myinterpreter-with-exception-handling ; 10
           '(planProg (planIf (planAdd 0 1) (planLet x 10 x) (planLet x 15 x))))
         => 10)

  ; additional test cases:
  (check (myinterpreter-with-exception-handling ; 11 -> 1
        '(planProg 5))
      => 5)

  (check (myinterpreter-with-exception-handling ; 12 -> 2
        '(planProg (planAdd (planAdd 7 (planIf (planMul 4 5) 0 10)) (planMul 2 5))))
      => 17)

  (check (myinterpreter-with-exception-handling ; 13 -> 3
        '(planProg (planLet z (planAdd 4 5) (planMul z 2))))
      => 18)

  (check (myinterpreter-with-exception-handling ; 14 -> 4
        '(planProg (planLet a 66 (planAdd (planLet b (planMul 2 4) (planAdd 2 b)) (planMul 2 a)))))
      => 142)

  (check (myinterpreter-with-exception-handling ; 15 -> 5
        '(planProg (planLet x 66 (planAdd (planLet x (planMul 2 4) (planAdd 2 x)) (planMul 2 x)))))
      => 142)

  ; extra credit test cases:
  (check (myinterpreter-with-exception-handling ; 16 -> 1
        '(planProg (planLet a (planFunction b (planAdd b b)) (a 5))))
      => 10)

  (check (myinterpreter-with-exception-handling ; 17 -> 2
        '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a 1 (planMul a a)))))
      => 1)

  ; ---
  (check (myinterpreter-with-exception-handling ; 18 -> 3
        '(planProg (planLet a (planFunction b (planAdd b b)) (a 5))))
      => 10)

  (check (myinterpreter-with-exception-handling ; 19 -> 4
        '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a 1 (planMul a a)))))
      => 1)

  (check (myinterpreter-with-exception-handling ; 20 -> 5
        '(planProg (planLet a (planFunction b (planAdd b b)) (planAdd (a 5) (a 5)))))
      => 20)

  (check (myinterpreter-with-exception-handling ; 21 -> 6
        '(planProg (planLet a (planFunction b (planAdd b b)) (planLet a (planFunction b (planMul b b)) (a 5)))))
      => 25)

  ; another test case:
  (check (myinterpreter-with-exception-handling ; 22 -> 1
        '(planProg (planLet a (planFunction b (planLet x 100 x)) (planAdd (a 5) (a 6)))))
      => 200)

  (display "Result:")
  (check-report))))