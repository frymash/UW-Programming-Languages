(* Enumerations -- a one-of type containing one of 
multiple values of the same type. *)

datatype suit = Club | Diamond | Heart | Spade

datatype rank = Jack | King | Queen | Ace
              | Num of int

datatype traffic_light = Red | Yellow | Green


(* *)
datatype id = StudentNum of int
            | Name of string
                      * (string option)
                      * string


(* Expression trees *)

datatype exp = Constant of int
             | Negate of exp
             | Add of exp * exp
             | Multiply of exp * exp

(* Evaluates an expression e *)
(* exp -> int *)
fun eval e =
    case e of
        Constant i        => i
      | Negate e1         => ~ (eval e1)
      | Add (e1, e2)      => (eval e1) + (eval e2)
      | Multiply (e1, e2) => (eval e1) * (eval e2)

(* val e = eval (Add (Add (Constant 4, Constant 10), Negate (Constant 2))) --> (+ (+ 4 10) (-2)) -> 12 *)
