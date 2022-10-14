#lang racket

(provide (all-defined-out))


; an addition function that's deliberately designed to be very slow
(define (slow-add x y)
  (letrec ([slow-id (lambda (y z)
                      (if (= z 0)
                          y
                          (slow-id y (- z 1))))])
    (+ (slow-id x 50000000) y)))


; multiplies x with the result of y-thunk by calling y-thunk x times
(define (my-mult x y-thunk)
  (cond [(= x 0) 0]
        [(= x 0) (y-thunk)]
        [#t (+ (y-thunk) (my-mult (- x 1) y-thunk))]))


; slow: (my-mult 2 (lambda () (let ([x (slow-add 3 4)]) x)))
; requires recomputation of x (result of thunk) every time the thunk is called

; fast: (my-mult 2 (let ([x (slow-add 3 4)]) (lambda () x)))
; saves the result of the thunk as x and calls x whenever the thunk is called
