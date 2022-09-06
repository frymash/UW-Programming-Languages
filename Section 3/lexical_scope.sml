val x = 1
fun f y = x + y
val x = 2
val y = 3

(* f uses environment in line 2 where x = 1 *)
(* f(2+3) = f(5) = 1+5 = 6 *)
val z = f(x + y) = 6

fun g y = x + y

(* g uses environment in line 10 where x = 2 *)
(* g(2+3) = g(5) = 2+5 = 7 *)
val a = g(x + y) =  7