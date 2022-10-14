#lang racket

(provide (all-defined-out))

; equivalent to the following in ML:
; fun pow1 x y = if y=0 then 1 else x * (pow1 x y-1)
(define (pow1 x y)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

; equivalent to the following in ML:
; val pow2 = fn x => fn y => pow1 x y
; this is a curried version of an exponentiation function
(define pow2
  (lambda (x)
    (lambda (y)
      (pow1 x y))))

; equivalent to the following in ML:
; val three-to-the = pow2 3
; this is a partial application of the curried function pow2
(define three-to-the (pow2 3))
