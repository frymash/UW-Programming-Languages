(* Enumerations -- a one-of type containing one of 
multiple values of the same type. *)

datatype suit = Club | Diamond | Heart | Spade

datatype rank = Jack | King | Queen | Ace
              | Num of int

datatype traffic_light = Red | Yellow | Green


(* id is one of:
		- StudentNum : int
		- Name : string
					 * (string option)
					 * string *)

(* Represents a student's integer ID if it exists.
	 Otherwise, represents a student's name *)
datatype id = StudentNum of int
            | Name of string
                      * (string option)
                      * string


(* Expression trees *)


(* exp is one of:
    - Constant (int)
    - Negate (exp)
    - Add (exp, exp)
    - Multiply (exp, exp) *)
datatype exp = Constant of int
             | Negate of exp
             | Add of exp * exp
             | Multiply of exp * exp

(* exp -> int *)
(* Evaluates an expression e *)

fun eval e =
    case e of
        Constant i        => i
      | Negate e1         => ~ (eval e1)
      | Add (e1, e2)      => (eval e1) + (eval e2)
      | Multiply (e1, e2) => (eval e1) * (eval e2)

val eval_test1 = eval (Add (Add (Constant 4, Constant 10), Negate (Constant 2))) = 12
val eval_test2 = eval (Multiply (Constant 10, Constant 12)) = 120
val eval_test3 = eval (Negate (Add (Multiply (Constant 5, Constant 3), Constant 7))) = ~ 22
