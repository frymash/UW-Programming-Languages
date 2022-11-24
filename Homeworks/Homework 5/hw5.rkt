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
        [(call? e)
         (let ([cl (eval-under-env (call-funexp e) env)]
               [arg (eval-under-env (call-actual e) env)])
           (if (not (closure? cl))
               (error "TypeError: Function call is not a closure")
               (eval-under-env (fun-body (closure-fun cl))
                               (cons (cons (fun-nameopt (closure-fun cl))      ; map the closure's fn to the fn name and cons to local env
                                            cl)                    
                                     (cons (cons (fun-formal (closure-fun cl))       ; map the call's arg to the fn parameter name and cons to local env
                                                 arg)                          
                                           (closure-env cl))))))]
        [(mlet? e)
         (let ([v (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e)
                           (cons (cons (mlet-var e) v)
                                  env)))]
        [(apair? e)
         (apair (eval-under-env (apair-e1 e) env)
                (eval-under-env (apair-e2 e) env))]
        [(fst? e)
         (eval-under-env (apair-e1 (fst-e e)) env)]
        [(snd? e)
         (eval-under-env (apair-e2 (snd-e e)) env)]
        [(aunit? e) e]
        [(isaunit? e)
         (if (equal? (aunit)(isaunit-e e))
             (int 1)
             (int 0))]
        [(closure? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3) "CHANGE")

(define (mlet* lstlst e2) "CHANGE")

(define (ifeq e1 e2 e3 e4) "CHANGE")

;; Problem 4

(define mupl-map "CHANGE")

(define mupl-mapAddN 
  (mlet "map" mupl-map
        "CHANGE (notice map is now in MUPL scope)"))

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
