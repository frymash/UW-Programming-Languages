#lang racket

(provide (all-defined-out))

(define l1 (list 1 2 3 4 (list 5) "h1" 9))


;; List[num] -> Number
(define (sum3 xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (sum3 (cdr xs)))]
        [(list? (car xs)) (+ (sum3 (car xs)) (sum3 (cdr xs)))]
        [#t (sum3 (cdr xs))]))


(define l2 (list 1 2 3 4 5 8 3 10))

(define (max-of-list xs)
  (cond [(null? xs) (error "ValueError: list is empty")]
        [(null? (cdr xs)) (car xs)]
        [#t (let ([tlans (max-of-list (cdr xs))])
              (if (> tlans (car xs))
                  tlans
                  (car xs)))]))


; Use of let --
; The definitions in a Racket let expression are evaluated in the
; environment BEFORE the let expression.
; The trampoline call, however, is evaluated in the environment with
; the local bindings.
; In this example, all mentions of x in the local bindings refer to
; the function parameter x (which is from the env outside the let
; expression).
(define (silly-double1 x)
  (let ([x (+ x 3)]
        [y (+ x 2)])
    (+ x y -5)))


; Use of let* --
; Identical to an ML let expression; definitions in a Racket let* expression
; are evaluated within the environment with the local bindings

(define (silly-double2 x)
  (let* ([x (+ x 4)]
         [y (+ x 5)])
    (+ x y -13)))


; Use of letrec

