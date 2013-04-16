(define (count-pairs x)
    (define distinct-pairs (list x))
    (define (count elem)
        (cond ((or (not (pair? elem)) 
                   (elem-in-set? elem distinct-pairs)) 0)
              (else (begin (set! distinct-pairs (cons elem distinct-pairs))
                           (+ 1 (count (car elem)) (count (cdr elem)))))))
    (+ 1 (count (car x)) (count (cdr x))))

(define (elem-in-set? elem set)
    (cond ((null? set) false)
          ((eq? elem (car set)) true)
          (else (elem-in-set? elem (cdr set)))))
