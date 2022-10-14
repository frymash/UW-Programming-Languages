#lang racket

(provide (all-defined-out))

(define b 3)
(define f (lambda (x) (+ x b))) ; (f 4) -> 9

(define c (+ b 4))   ; 7
(set! b 5)           ; from here, b = 5
(define z (f 4))     ; 9
(define w c)         ; 7 (this is because b = 3 when c was defined)


(define g
  (let ([b b]
        [+ +]
        [* *]) ; value of b will always be 5 in this function
    (lambda (x) (* 1 (+ x b)))))
(set! b 4) ; change of b's value here won't affect value of b in g

(define next-number!
  (let ([n 0])
    (lambda ()
      (set! n (add1 n))
      n)))