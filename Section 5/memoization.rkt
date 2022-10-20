#lang racket

; note that this function is a closure - we could
; write it as (define (factorial3 n) (.. (f n)))
; but we'll write it this way to avoid unnecessary function wrapping

(define factorial3
  (letrec ([memo null] ; memo is a list of pairs (n, ans)
                       ; where ans is the fib number for n
           [f (lambda (n)
                (let ([ans (assoc n memo)])
                  (if ans
                      (cdr ans)
                      (let ([new-ans (if (or (= n 1) (= n 2))
                                         1
                                         (+ (f (- n 1))(f (- n 2))))])
                        (begin
                          (set! memo (cons (cons n new-ans) memo))
                          new-ans)))))])
    f))