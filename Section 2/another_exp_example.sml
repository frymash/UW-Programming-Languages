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
(* returns the highest constant in an expression*)

fun max_constant e =
    case e of
          Constant i        => i
        | Negate e1         => max_constant e1
        | Add (e1, e2)      => Int.max (max_constant e1, max_constant e2)
        | Multiply (e1, e2) => Int.max (max_constant e1, max_constant e2)


(* fun max_constant e =

    (* exp exp -> int *)  
    (* evaluates 2 expressions and returns the greater result*)           
    let
        fun greater_exp (e1,e2) =
            let val e1_max = max_constant e1
                val e2_max = max_constant e2
        in
            if e1_max > e2_max
            then e1_max
            else e2_max
        end

    in 
        case e of
              Constant i        => i
            | Negate (e1)        => max_constant e1
            | Add (e1, e2)      => greater_exp (e1, e2)
            | Multiply (e1, e2) => greater_exp (e1, e2)
    
    end *)

(* Test 1 *)
val test_exp = Add (Constant 19, Negate (Constant 4))
val nineteen = max_constant test_exp = 19

(* Test 2 *)
val test_exp2 = Multiply (Add (Constant 45, Multiply (Constant 10, Constant 12)), Constant 16)
val fortyfive = max_constant test_exp2 = 45
