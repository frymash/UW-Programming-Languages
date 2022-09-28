(* 1st version of function A *)
fun h x =
	let
		val y = 3
	in
		x+y
	end

(* 2nd version of function A -- will always return 6 *)
fun g y =
	let
		val y = 3
	in
		y+y
	end


(* Another function *)

(* 1st version of function B *)
val k = 14
val k = 7
fun a z = (z+k+z)+z

(* 2nd version of function B *)
val y = 14
fun f x = x+y+x       (* y = 14 in this environment *)
val y = 7
fun b z = (f z)+z     (* y = 7 in this environment *)