fun n_times (f,n,x) =
    if n=0
    then x
    else f(n_times (f,n-1,x))

(* To demonstrate how anon funcs work, let's start by creating
   a function that triples a given input x by n times. We'll call
   it triple_n_times.

   The 1st version defines a helper function that triples its input.
   However, since this function is defined at top level, it's
   accessible globally. Given that the helper function will only
   be used by triple_n_times, defining the helper at top level
   isn't good style.

   fun triple x = 3*x

   fun triple_n_times (n,x) =
      n_times (triple,n,x)


   The 2nd version involves the defining of a local function
   which is then passed into n_times. Narrowing the scope in
   which the triple function is accessible is better style,
   but still not quite the best.

   fun triple_n_times (n,x) =
     let
         fun triple x = 3*x
     in
         n_times (triple,n,x)
     end

  
   The 3rd version narrows the scope of the tripling function even
   further by squeezing the definition for whole helper function
   into an argument for n_times. Although the concept of defining
   a single-use function only at a place where it's needed is
   considered good style, it isn't good style to use a let expression
   as a function argument (makes for pretty unreadable code as well).

   fun triple_n_times (n,x) =
      n_times (let fun triple x = 3*x in triple end, n,x)

   
   The final version rewrites the let expression into an anonymous function
   (which is a lot easier on the eyes). This version of triple_n_times
   has the best style out of all the versions presented thus far. *)

fun triple_n_times (n,x) =
    n_times ((fn y => 3*y), n, x)

val nine = triple_n_times (2,1) = 9
