(define (distinct? elems)
    (define (in? elem elems)
        (cond ((null? elems) false)
              ((= elem (car elems)) true)
              (else (in? elem (cdr elems)))))
    (define (distinct-loop elems)
        (cond ((null? elems) true)
              ((in? (car elems) (cdr elems)) false)
              (else (distinct-loop (cdr elems)))))
    (distinct-loop elems))

(define (logic-puzzle)
    (define (check-restrictions baker cooper fletcher miller smith)
        (and (distinct? (list baker cooper fletcher miller smith))
             (not (= baker 5))
             (not (= cooper 1))
             (not (= fletcher 5))
             (not (= fletcher 1))
             (> miller cooper)
             (not (= (abs (- smith fletcher)) 1))
             (not (= (abs (- fletcher cooper)) 1))))
    (define (next-batch baker cooper fletcher miller smith)
        (cond ((= baker cooper fletcher miller smith 5) "No luck. Reached the end of the line")
              ((= cooper fletcher miller smith 5) (solver-loop (+ baker 1) 1 1 1 1))
              ((= fletcher miller smith 5) (solver-loop baker (+ cooper 1) 1 1 1))
              ((= miller smith 5) (solver-loop baker cooper (+ fletcher 1) 1 1))
              ((= smith 5) (solver-loop baker cooper fletcher (+ miller 1) 1))
              (else (solver-loop baker cooper fletcher miller (+ smith 1)))))
    (define (solver-loop baker cooper fletcher miller smith)
        (if (check-restrictions baker cooper fletcher miller smith)
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))
            (next-batch baker cooper fletcher miller smith)))
    (solver-loop 1 1 1 1 1))

;Result
;((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
