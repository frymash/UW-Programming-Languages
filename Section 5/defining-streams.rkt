#lang racket

; recap: a stream is a thunk that returns the pair '(next-answer . next-thunk)
; when it is called.

; stream of 1s
(define ones (lambda () (cons 1 ones)))


; stream of natural numbers
(define (f x) (lambda () (cons x (lambda () (f (+ x 1))))))
(define nats (lambda () (f 1))) ; works with additional parentheses
                                ; but not so good in practice

(define naturals
  (letrec ([f (lambda (n)
                (cons n (lambda () (f (+ n 1)))))])
    (lambda () (f 1))))


; stream of powers of 2
(define powers-of-two
  (letrec ([f (lambda (n)
                (cons n (lambda () (f (* n 2)))))])
    (lambda () (f 1))))
