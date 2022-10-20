#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

;; Stream is a thunk that evaluates to
;; (cons (Natural[0,5] * String) Stream))

;; Template
#;
(define s
  (letrec ([f (lambda (...)
                (cons ... (lambda () (f ...))))])
    (lambda () (f ...))))


;; Template
#;
(define (fn-for-stream s)
  (... (car (s))
       (... ((cdr (s))))))


;; Homework functions begin here.

;; (Q1)
;; Number * Number * Number -> Number list
;; Given 3 numbers (low, high, and stride) and assuming
;; stride is positive, produces a list of numbers from
;; low to high (including low and possibly high)
;; separated by stride and in sorted order.

(define (sequence low high stride)
  (if (or (> low high)(<= stride 0))
      null
      (cons low (sequence (+ low stride) high stride))))


;; (Q2)
;; String list * String -> String list
;; takes a list of strings xs and appends a string
;; suffix to every one of its elements
(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))


;; (Q3)
;; 'a list * Number -> 'a
;; Return the ith element of xs where we count
;; from 0 and i is the remainder produced when
;; dividing n by the xs's length.
;; Throw an error if n < 0 or if the xs is empty.

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (define (loop xs i)
              (if (= i 0)
                  (car xs)
                  (loop (cdr xs)(- i 1))))
            (loop xs (remainder n (length xs)))]))


;; (Q4)
;; X Stream * Number -> X list
;; Returns a list holding the first n values
;; produced by s in order.

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s))
            (stream-for-n-steps (cdr (s)) (- n 1)))))


;; (Q5)
;; funny-number-stream is a Natural Stream that
;; is like a stream of natural numbers except numbers
;; divisible by 5 are negated
;; (i.e., 1, 2, 3, 4, -5, 6, 7, 8, 9, -10, 11, ...)

(define funny-number-stream
  (letrec ([build-stream (lambda (n)
                           (if (= (remainder n 5) 0)
                               (cons (- 0 n) (lambda () (build-stream (+ n 1))))
                               (cons n (lambda () (build-stream (+ n 1))))))])
    (lambda () (build-stream 1))))


;; (Q6)
;; dan-then-dog is a String Stream that
;; alternates between "dan.jpg" and "dog.jpg"

(define dan-then-dog
  (letrec ([alt (lambda (img1 img2)
                    (cons img1 (lambda () (alt img2 img1))))])
      (lambda () (alt "dan.jpg" "dog.jpg"))))

;; curried version:
;; (define dan-then-dog
;;   (letrec ([alt (lambda (img1)
;;                   (lambda (img2)
;;                     (cons img1 (lambda () ((alt img2) img1)))))])
;;       (lambda () ((alt "dan.jpg") "dog.jpg"))))


;; (Q7)
;; X Stream -> (0 . X) Stream
;; takes a stream s (i.e. v1, v2, v3...))
;; and returns a new stream every value v
;; from the input stream is converted
;; to a pair (0,v) in the new stream
;; (i.e. (0 . v1), (0 . v2), (0 . v3))

(define (stream-add-zero s)
  (letrec ([build-stream (lambda (s)
                           (cons (cons 0 (car (s)))
                                 (lambda () (build-stream (cdr (s))))))])
    (lambda () (build-stream s))))


;; (Q8)
;; X list * Y list -> (X . Y) Stream
;; returns a stream whose nth element is a pair (v1, v2)
;; where v1 is the nth element of xs
;; and v2 is the nth element of ys.

;; Note: I couldn't
(define (cycle-lists xs ys)
  (letrec ([build-stream (lambda (xs ys)
                           (cons (cons (car xs)(car ys))
                                 (lambda () (build-stream (append (cdr xs)(list (car xs)))
                                                          (append (cdr ys)(list (car ys)))))))])
    (lambda () (build-stream xs ys))))


;; (Q9)
;; X * Y Vector -> Y | #f
;; behaves like Racket's assoc function

(define (vector-assoc v vec)
  (letrec ([valid-indexes (let ([v-len (vector-length vec)])
                            (and (not (= v-len 0))(- v-len 1)))]
           [check-index (lambda (i)
                          (let ([target (vector-ref vec i)])
                            (cond [(or (not (pair? target))
                                       (not (equal? v (car target))))
                                   (and (not (> (+ i 1) valid-indexes))
                                        (check-index (+ i 1)))]
                                  [#t target])))])
    (check-index 0)))


;; (Q10)
;; (X . Y) list * Number -> (X -> (X . Y)) | #f
;; Alternate version of the assoc function
;; with memoization.

(define (cached-assoc xs n)
  (letrec ([cache (make-vector n)]
           [next-cache-slot 0]
           [aux (lambda (v)
                  (let ([in-cache (vector-assoc v cache)]
                        [assoc-delay (mcons #f (lambda () (assoc v xs)))]
                        [assoc-force (lambda (p)
                                       (if (mcar p)
                                           (mcdr p)
                                           (begin (set-mcar! p #t)
                                                  (set-mcdr! p ((mcdr p)))
                                                  (mcdr p))))])
                    (if (false? in-cache)
                        (and (assoc-force assoc-delay)
                            (begin (vector-set! cache next-cache-slot (mcdr assoc-delay))
                                   (if (= (- n 1) next-cache-slot)
                                       (set! next-cache-slot 0)
                                       (set! next-cache-slot (+ 1 next-cache-slot)))
                                   (mcdr assoc-delay)))
                        in-cache)))])
    aux))
