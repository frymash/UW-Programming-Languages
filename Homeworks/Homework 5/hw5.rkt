;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function; nameopt: fun name, formal: function parameter, body: function body
(struct call (funexp actual)       #:transparent) ;; function call; funexp: closure, actual: function argument
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

;; Q1a)
;; 'a list -> 'a apair
;; takes a Racket list and produces an analogous MUPL list
;; with the same elements in the same order
(define (racketlist->mupllist xs)
  (if (null? xs)
      (aunit)
      (apair (car xs)(racketlist->mupllist (cdr xs)))))


;; Q1b)
;; 'a apair | aunit -> 'a list
;; takes a MUPL list and produces an analogous Racket list
;; with the same elements in the same order
(define (mupllist->racketlist xs)
  (if (equal? xs (aunit))
      null
      (cons (apair-e1 xs)
            (mupllist->racketlist (apair-e2 xs)))))


;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(int? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (cond [(not (int? v1))(error ("TypeError: 1st argument is not an integer"))]
                 [(not (int? v2))(error ("TypeError: 2nd argument is not an integer"))]
                 [#t
                  (if (> (int-num v1) (int-num v2))
                      (eval-under-env (ifgreater-e3 e) env)
                      (eval-under-env (ifgreater-e4 e) env))]))]
        [(fun? e)
         (closure env e)]
        [(call? e) ; MUPL calls are used whenever you call a function and pass arguments through it
         (let ([cl (eval-under-env (call-funexp e) env)])
           (if (not (closure? cl))
               (error "TypeError: Function call is not a closure")
               (let ([arg (eval-under-env (call-actual e) env)]
                     [fn-name (fun-nameopt (closure-fun cl))]
                     [fn-parameters (fun-formal (closure-fun cl))]
                     [fn-body (fun-body (closure-fun cl))])
                 (if (string? fn-name)                                    ; if the function is anonymous, don't add it's name (#f) to the local env
                     (eval-under-env fn-body
                                     (cons (cons fn-name cl)              ; map the closure's fn to the fn name and cons to the local env            
                                           (cons (cons fn-parameters arg) ; map the call's arg to the fn parameter name and cons to the local env            
                                                 (closure-env cl))))
                     (eval-under-env fn-body (cons (cons fn-parameters arg)
                                                   (closure-env cl)))))))]
        [(mlet? e)
         (let ([v (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e)
                           (cons (cons (mlet-var e) v)
                                  env)))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e)
         (let ([v (eval-under-env (fst-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "TypeError: Argument passed to fst is not a pair")))]
        [(snd? e)
         (let ([v (eval-under-env (snd-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "TypeError: Argument passed to snd is not a pair")))]
        [(aunit? e) e]
        [(isaunit? e)
         (if (aunit? (eval-under-env (isaunit-e e) env))
             (int 1)
             (int 0))]
        [(closure? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))


;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

;; Q3a)
;; MUPL exp * MUPL exp * MUPL exp -> MUPL exp
;; returns a MUPL expression that does the following when evaluated:
;; returns the result of evaluating e2 if e1 is aunit.
;; else, it returns the result of evaluating e3
(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1)
             (int 0)
             e2
             e3))


;; Q3b)
;; ('a.'b) list * MUPL exp -> MUPL exp
;; returns a MUPL expression that evaluates e2 in an environment
;; where each ('a.'b) pair represents a variable name-value pair
(define (mlet* lstlst e2)
  (call (closure lstlst (fun #f "" e2)) (int 0))) ; simulate a 0-argument anon function
                                                  ; since closures require a function part
                                                  ; but assign (int 0) to "" as
                                                  ; 1 argument is required for fun in MUPL


;; Q3c)
;; MUPL exp * MUPL exp * MUPL exp * MUPL exp -> MUPL exp
;; acts like ifgreater except e3 is evaluated if and only if e1 and e2 are
;; equal integers.
;; assume none of the arguments to ifeq use the mupl variables _x or _y.
;; use this assumption so that when an expression returned from ifeq is evaluated,
;; e1 and e2 are evaluated exactly once each.
(define (ifeq e1 e2 e3 e4)
  (mlet "v1" (eval-exp e1)
        (mlet "v2" (eval-exp e2)
              (ifgreater (var "v1")
                         (var "v2")
                         e4
                         (ifgreater (var "v2")
                                    (var "v1")
                                    e4
                                    e3)))))


;; Problem 4

;; Q4a)
;; ('a -> 'b) MUPL function -> MUPL function
;; takes a MUPL function and returns a MUPL function that takes a MUPL list and
;; applies the function to every element of the list,
;; returning a new MUPL list
(define mupl-map
  (fun #f "f"
       (fun "muplmap" "xs"
            (ifaunit (var "xs")
                     (aunit)
                     (apair (call (var "f")(fst (var "xs")))
                            (call (var "muplmap")(snd (var "xs"))))))))


;; Q4b)
;; MUPL int -> (MUPL int list -> MUPL int list)
;; takes an mupl integer i and returns a mupl function that
;; takes a mupl list of mupl integers and returns a new mupl list of
;; mupl integers that adds i to every element of the list
(define mupl-mapAddN
  (fun #f "i"
       (mlet "map" mupl-map
             (fun "f" "xs"
                  (call (call (var "map") (fun #f "x" (add (var "x")(var "i"))))
                        (var "xs"))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
