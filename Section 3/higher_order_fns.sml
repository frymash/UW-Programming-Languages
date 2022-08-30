fun double x = x + x
fun incr x = x + 1
val a_tuple = (double, incr, double (incr 7))
val eighteen = (#1 a_tuple) 9

fun map2 (xs, f) =
	case xs of
		  [] => []
		| x::xs' => f x :: map2 (xs', f)
