#lang racket

(provide (all-defined-out))

(define x1 (cons 1 2))
(define x2 (cons 3 (cons 4 5)))
(define x3 (cons (cons 6 (cons 7 (cons 8 null))) null))
(define x4 (cons "a" (cons "b" (cons "c" (cons "d" null)))))