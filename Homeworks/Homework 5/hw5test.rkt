#lang racket
;; Programming Languages Homework 5 Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests. Passing these tests does not guarantee that your code will pass the actual homework grader

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and, if necessary, change the filename
(require "hw5.rkt")

(require rackunit)

(define tests
  (test-suite
   "Sample tests for Assignment 5"

   ;; envlookup tests
   (check-equal? (envlookup (list (cons "test" (var "a"))) "test") (var "a") "envlookup test 1")

   
   ;; check racketlist to mupllist with normal list
   (check-equal? (racketlist->mupllist (list (int 3))) (apair (int 3) (aunit)) "racketlist->mupllist test 1")
   (check-equal? (racketlist->mupllist (list (int 3) (int 4))) (apair (int 3) (apair (int 4) (aunit))) "racketlist->mupllist test 2")
   (check-equal? (racketlist->mupllist null) (aunit) "racketlist->mupllist test 2")

   ;; check mupllist to racketlist with normal list
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit)))) (list (int 3) (int 4)) "mupllist->racketlist test 1")
   (check-equal? (mupllist->racketlist (apair (int 3) (aunit))) (list (int 3)) "mupllist->racketlist test 2")
   (check-equal? (mupllist->racketlist (aunit)) null "mupllist->racketlist test 3")

   ;; tests for var
   (check-equal? (eval-under-env (var "a") (list (cons "a" (int 1)))) (int 1) "var test")

   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test")

   ;; mlet test
   (check-equal? (eval-exp (mlet "x" (int 1) (add (int 5) (var "x")))) (int 6) "mlet test")

   ;; call test
   (check-equal? (eval-exp (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1))) (int 8) "call test 1")
   (check-equal? (eval-exp (call (closure (list (cons "y" (int 7))) (fun #f "x" (add (var "x") (var "y")))) (int 1))) (int 8) "call test 2")

   ;; snd test
   (check-equal? (eval-exp (snd (apair (int 1) (int 2)))) (int 2) "snd test")

   ;; isaunit test
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test 1")
   (check-equal? (eval-exp (isaunit (aunit))) (int 1) "isaunit test 2")

   ;; ifaunit test
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test")

   ;; mlet* test
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10)))
                                  (var "x")))
                 (int 10) "mlet* test 1")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))(cons "y" (int 20)))
                                  (add (var "x")(var "y"))))
                 (int 30) "mlet* test 2")

   (check-equal? (eval-exp (mlet* (list (cons "x" (int 1000))
                                        (cons "x" (int 2))
                                        (cons "y" (add (var "x") (int 6)))
                                        (cons "z" (apair (var "x") (var "y"))))
                                  (var "z")))
                    (apair (int 2) (int 8)) "mlet* test 3")

   (check-equal? (eval-exp (mlet* `(("x" unquote (int 1000))
                                    ("x" unquote (int 2))
                                    ("y" unquote (add (var "x")(int 6)))
                                    ("z" unquote (apair (var "x") (var "y"))))
                                  (var "z")))
                 (apair (int 2) (int 8)) "mlet* test 4")

   (check-equal? (eval-exp (mlet* `(("x" unquote (add (int 1) (int 2)))) (var "x")))
                           (int 3) "mlet* test 5")



   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test")
   
   ;; mupl-map test
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (aunit)))) 
                 (apair (int 8) (aunit)) "mupl-map test")

    ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
   (eval-exp (call (call mupl-mapAddN (int 7))
                   (racketlist->mupllist 
                    (list (int 3) (int 4) (int 9)))))) (list (int 10) (int 11) (int 16)) "combined test")
   
   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
