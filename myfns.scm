(define (plan program)
  (evalPlanExpr (cadr program) '()))

(define (evalPlanExpr expr bindings)
  (cond
    ((integer? expr) expr)
    ((symbol? expr) (lookup expr bindings))
    ((equal? (car expr) 'planIf) (evalPlanIf expr bindings))
    ((equal? (car expr) 'planAdd) (evalPlanAdd expr bindings))
    ((equal? (car expr) 'planMul) (evalPlanMul expr bindings))
    ((equal? (car expr) 'planSub) (evalPlanSub expr bindings))
    ((equal? (car expr) 'planLet) (evalPlanLet expr bindings))
    ((symbol? (car expr)) (evalPlanFunc expr bindings))))

(define (evalPlanIf expr bindings)
  (cond
    ((> (evalPlanExpr (cadr expr) bindings) 0) 
     (evalPlanExpr (caddr expr) bindings))
    (else (evalPlanExpr (cadddr expr) bindings))))

(define (evalPlanAdd expr bindings)
  (+ (evalPlanExpr (cadr expr) bindings)
     (evalPlanExpr (caddr expr) bindings)))

(define (evalPlanMul expr bindings)
  (* (evalPlanExpr (cadr expr) bindings)
     (evalPlanExpr (caddr expr) bindings)))

(define (evalPlanSub expr bindings)
  (- (evalPlanExpr (cadr expr) bindings)
     (evalPlanExpr (caddr expr) bindings)))

(define (evalPlanLet expr bindings)
  (cond
    ((and (pair? (caddr expr)) (equal? (car (caddr expr)) 'planFunction))
     (evalPlanExpr (cadddr expr)
                   (cons (cons (cadr expr) (caddr expr)) bindings)))
    (else
     (evalPlanExpr (cadddr expr)
                   (cons (cons (cadr expr)
                               (evalPlanExpr (caddr expr) bindings)) 
                         bindings)))))

(define (lookup identifier bindings)
  (cond
    ((equal? identifier (caar bindings)) (cdar bindings))
    (else (lookup identifier (cdr bindings)))))

(define (evalPlanFunc expr bindings)
  (evalPlanExpr
    (caddr (lookup (car expr) bindings))
    (cons (cons (cadr (lookup (car expr) bindings))
                (evalPlanExpr (cadr expr) bindings))
          bindings)))
