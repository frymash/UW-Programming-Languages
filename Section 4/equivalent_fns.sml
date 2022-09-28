fun g (f, x) =
    (f x) + (f x)

val y = 2
fun h (f, x) =
    y * (f x)

(* Both functions would be equivalent if f is a pure function e.g. (fn j => 3*j,2)
   For example, if the anonymous function (fn j => 3*j), is passed to
   g and h, both functions will produce the same numerical result (12).

   Moreover, both functions will not produce any side effects in this
   situation. It would be impossible for clients to tell g or h apart
   if the implementation details are hidden behind
   a layer of abstraction. *)


(* Both functions would not be equivalent if f causes side effects
   e.g. (fn i => (print "hi"; i),7)
   
   If the anonymous function (fn i => (print "hi"; i),7)
   is passed to g and h, both functions will produce the same
   numerical result (14).

   However, since each call of the anonymous function prints "hi",
   g would print "hihi" (since f is called 2x in g) as compared to h
   which will print "hi" (since f is called 1x in h).

   In this situation, g and h would NOT be equivalent since they produce
   different side effects (i.e. print different things) *)