datatype two_nums = twoNumStr of string * string
                  | twoNumInt of int * int
                  | noNum


datatype tree = Node of {data : int, left : tree, right : tree}
              | Leaf


(* Every branch in a case expression must return the same type. *)
(* Every variant of the tagged union should be accounted for
   in the case expression. *)
(* two_nums -> string *)
fun add_two_nums (tn : two_nums) = 
    case tn of
          twoNumStr (s1, s2) => s1 ^ " " ^ s2
        | twoNumInt (i1, i2) => "A number"
        | noNum => "None"
