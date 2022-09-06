(* There will be 2 examples here to demonstrate how lexical
   scope works at a deeper level. *)

(* First example *)
val x = 1

(* int -> (int -> int) *)
(* Whenever f is run, it will use its local binding of x in its
   function body and NOT the global binding of x (which is 1
   in the current environment). This is because lexical scoping
   involves searching for the variables used within the local scope
   first. It will only use the global definition of x if x isn't
   defined locally. *)
fun f y =
    let
        val x = y + 1
    in
        fn z => x + y + z
    end

val x = 3 (* actually irrelevant because it won't be called *)
val g = f 4
val y = 5 (* also irrelevant since it won't be called either *)
val z = g 6 (* g 6 = (f 4)(6) = (fn z => 5+4+z)(6) = 5+4+6 = 15 *)


(* Second example *)

(* (int -> 'a) -> 'a *)
fun f g =
    let
        val x = 3
        (* this binding is actually irrelevant since x isn't
           used in the "in" expression and will go out of scope
           after the function is evaluated *)
    in
        g 2
    end

val x = 4
fun h y = x + y (* in the current dynamic environment when h is defined,
                   x --> 4 *)
val z = f h (* will produce 6 since the local binding for x in the function
               body for f won't be used.  the function h takes
               x --> 4 when it is passed to f *)
