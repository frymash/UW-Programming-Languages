(*

(* int * int -> int list *)
(* returns a list consisting every number from first to last *)
fun count (first : int, last : int) =
    if first = last
    then last :: []
    else first :: count(first + 1, last)


(* int -> int list *)
(* returns a list counting from 1 to x *)
fun count_from_1 (x : int) = 
    count (1, x)


(* An inferior example of how to nest count within count_from_1 *)

fun count_from_1 (x : int) = 
    let
        fun count (first : int, last : int) =
            if first = last
            then last :: []
            else first :: count(first + 1, last)
    in
        count (1, x)
    end


*)


(* A superior example of how to nest count within count_from_1 *)
fun count_from_1 (x : int) = 
    let
        fun count (first : int) =
            if first = x
            then x :: []
            else first :: count(first + 1)
    in
        count (1)
    end
