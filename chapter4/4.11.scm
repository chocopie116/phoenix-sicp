(define (make-frame variables values)
    (list (map (lambda (var val) (cons var val))
               variables
               values)))
(define (bindings frame) (car frame))
(define (first-binding b) (car b))
(define (rest-bindings b) (cdr b))
(define (var-binding b) (car b))
(define (val-binding b) (cdr b))
(define (set-val-binding! b val) (set-cdr! b val))
(define (add-binding-to-frame! var val frame)
    (set-car! frame (cons (cons var val) (car frame))))


(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan bindings)
      (if (null? bindings)
          (env-loop (enclosing-environment env))
          (let ((b (first-binding bindings)))
            (if (eq? (var-binding b) var)
                (val-binding b)
                (scan (rest-bindings bindings))))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (scan (bindings (first-frame env)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan bindings)
      (if (null? bindings)
          (env-loop (enclosing-environment env))
          (let ((b (first-binding bindings)))
            (if (eq? (var-binding b) var)
                (set-val-binding! b val)
                (scan (rest-bindings bindings))))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (scan (bindings (first-frame env)))))
  (env-loop env))

(define (define-variable! var val env)
    (define (scan bindings)
      (if (null? bindings)
          (add-binding-to-frame! var val (first-frame env))
          (let ((b (first-binding bindings)))
            (if (eq? (var-binding b) var)
                (set-val-binding! b val)
                (scan (rest-bindings bindings))))))
    (scan (bindings (first-frame env))))
