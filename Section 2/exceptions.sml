(* 'a list -> 'a *)
fun hd xs =
	case xs of
			[] => raise List.Empty
		| x::_ => x

val hd_test1 = hd [] handle List.Empty => "List.empty error"
val hd_test2 = hd [1] = 1
val hd_test3 = hd [2,3,4] = 2


exception NumberedException of int * int
exception MyUndesirableCondition


fun mydiv (x,y) =
    if y=0
    then raise MyUndesirableCondition
    else x div y 

(* int list * exn -> int *)
fun maxlist (xs,ex) = 
    case xs of
        [] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x,maxlist(xs',ex))

val w = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)

val x = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)
	handle MyUndesirableCondition => 42

(* will throw an MyUndesirableCondition exception *)
(* val y = maxlist ([],MyUndesirableCondition) *)

val z = maxlist ([],MyUndesirableCondition) (* 42 *)
	handle MyUndesirableCondition => 42