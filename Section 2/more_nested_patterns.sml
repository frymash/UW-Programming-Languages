(* Let's begin with a not-so-great implementation of our 1st function:
nondecreasing *)

(* This implementation of nondecreasing features a nested case
expression *)

(* int list -> bool *)
(* a function that returns true if all its elements 
are sorted in non-decreasing order *)


(* 
fun nondecreasing xs = 
	case xs of
		  [] => true
        | x::xs' => case xs' of
					      [] => true
					    | y::ys => x<=y
								   andalso nondecreasing ys *)


(* The next implementation of nondecreasing is much better as
it removes the unnecessary nested case expression through the
use of a nested pattern. *)

(* int list -> bool *)
(* a function that returns true if all its elements 
are sorted in non-decreasing order *)

fun nondecreasing xs = 
	case xs of
		  [] => true
        | _::[] => true  
		| head::(neck::rest) => head <= neck 
                                andalso nondecreasing (neck::rest)


(* "head <= neck andalso nondecreasing (neck::rest)"
   
	 is syntactic sugar for

	 "if head <= neck
	  then nondecreasing (neck::rest)
	  else false" *)

val nondecreasing_test1 = nondecreasing [] = true
val nondecreasing_test2 = nondecreasing [1] = true
val nondecreasing_test3 = nondecreasing [1,2] = true
val nondecreasing_test4 = nondecreasing [2,1] = false
val nondecreasing_test5 = nondecreasing [1,2,3] = true
val nondecreasing_test6 = nondecreasing [1,1,2,3] = true
val nondecreasing_test7 = nondecreasing [3,2,1] = false
val nondecreasing_test8 = nondecreasing [3,3,2,4] = false


(* int * int -> sgn *)

(* sgn is one of 3 numerical signs:
		- Z (zero)
		- P (positive)
		- N (negative) *)

datatype sgn = Z | P | N

(* int * int -> sgn *)
(* returns the sign of the product of 2 integers, x and y *)

fun multsign (x,y) = 
		let
				fun sign x = if x=0 then Z else if x>0 then P else N
		in
				case (sign x, sign y) of
						  (Z, _) => Z
						| (_, Z) => Z
						| (P, P) => P
						| (N, N) => P
						| _      => N
		end

val multsign_test1 = multsign (0,1) = Z
val multsign_test2 = multsign (1,0) = Z
val multsign_test3 = multsign (0,~1) = Z
val multsign_test4 = multsign (~1,0) = Z
val multsign_test5 = multsign (1,1) = P
val multsign_test6 = multsign (~1,~1) = P
val multsign_test7 = multsign (~1,1) = N
val multsign_test8 = multsign (1,~1) = N


