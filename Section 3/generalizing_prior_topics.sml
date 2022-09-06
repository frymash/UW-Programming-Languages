(* (int -> bool) -> (int -> int) *)
(* returns an anonymous function that doubles its input 
	 if f 7 is true. Else, it returns an anonymous function
	 that triples its input. *)
fun double_or_triple f =
	if f 7
	then fn x => 2*x
	else fn x => 3*x

(* returns the doubling function *)
val double = double_or_triple (fn x => x - 3 = 4)
val eight = double 4 = 8

(* double_or_triple expression returns the tripling function which
	 we'll feed with an int to get an int as output *)
val nine = (double_or_triple (fn x => x = 42)) 3 = 9