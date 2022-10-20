#lang racket

;; Programming Languages Homework4 Graphical Tests
;; Save this file to the same directory as your homework file
;; These are tests that use a little graphics to make the assignment more fun.

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and change HOMEWORK_FILE to the name of your homework file.
(require "hw4.rkt")

;; A simple library for displaying a 2x3 grid of pictures: used
;; for fun in the tests below (look for "Tests Start Here").  No need to understand
;; the graphics code, though it is not sophisticated.

(require (lib "graphics.rkt" "graphics"))

(open-graphics)

(define window-name "Programming Languages, Homework 4")
(define window-width 700)
(define window-height 500)
(define border-size 100)

(define approx-pic-width 200)
(define approx-pic-height 200)
(define pic-grid-width 3)
(define pic-grid-height 2)


; (no argument) -> Window
; Opens a new window with window-name's nameof window-width width,
; window-height height.
(define (open-window)
  (open-viewport window-name window-width window-height))


; Natural[0,5] -> Posn
; Converts a picture's grid position to
; its Posn in the actual window.
; e.g. If a picture's grid-posn is 5 and pic-grid-width is 3,
; the Posn of the picture would be (2,2)
(define (grid-posn-to-posn grid-posn)
  (when (>= grid-posn (* pic-grid-height pic-grid-width))
    (error "picture grid does not have that many positions"))
  (let ([row (quotient grid-posn pic-grid-width)]
        [col (remainder grid-posn pic-grid-width)])  
    (make-posn (+ border-size (* approx-pic-width col))
               (+ border-size (* approx-pic-height row)))))


; Window * String * Natural[0,5] -> Window
(define (place-picture window filename grid-posn)
  (let ([posn (grid-posn-to-posn grid-posn)])
    ((clear-solid-rectangle window) posn approx-pic-width approx-pic-height)
    ((draw-pixmap window) filename posn)))


; Window * Natural * Stream * Natural[<= 6] -> Window
; Feeds pictures from a stream to a 2x3 grid
; within a given window every pause seconds.
; The stream must feed a total of n images
; to the window.
(define (place-repeatedly window pause stream n)
  (when (> n 0)
    (let* ([next (stream)]          ; Stream is (cons (Natural[0,5] * String) Stream)
           [filename (cdar next)]   ; cdar of a Stream will be a String
           [grid-posn (caar next)]  ; caar of a Stream will be Natural[0,5]
           [stream (cdr next)])
      (place-picture window filename grid-posn)
      (sleep pause)
      (place-repeatedly window pause stream (- n 1)))))


;; Tests Start Here

; These definitions will work only after you do some of the problems
; so you need to comment them out until you are ready.
; Add more tests as appropriate, of course.

(define nums (sequence 0 5 1))

(define files (string-append-map 
               (list "dan" "dog" "curry" "dog2") 
               ".jpg"))

; a zero-argument function: call (one-visual-test) to open the graphics window, etc.
(define (one-visual-test)
  (place-repeatedly (open-window) 0.5 (cycle-lists nums files) 27))

; similar to previous but uses only two files and one position on the grid
(define (visual-zero-only)
  (place-repeatedly (open-window) 0.5 (stream-add-zero dan-then-dog) 27))
