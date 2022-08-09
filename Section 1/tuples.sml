(* (int * bool) -> (bool * int) *)
fun swap(pr : int * bool) =
    (#2 pr, #1 pr)


(* (int * int) * (int * int) -> int *)
fun sum_two_pairs(pr1 : int * int, pr2 : int * int) = 
    (#1 pr1) + (#2 pr1) + (#1 pr2) + (#2 pr2)


(* int * int -> int * int *)
fun div_mod(x : int, y: int) =
    (x div y, x mod y)


(* (int * int) -> (int * int) *)
fun sort_pair(pr : int * int) =
    if (#1 pr) < (#2 pr)
    then pr
    else (#2 pr, #1 pr)


val nested = (1, (true, 2))            (* int * (bool * int) *)
val nested2 = (#1 (#2 pr))             (* bool *)
val nested3 = (#2 pr)                  (* bool * int *)
val nested4 = ((1,2),(3,4),(5,6))      (* (int * int) (int * int) (int * int) *)



(* Test functions *)
val swap_test = swap(34, true) = (true, 34)
val swap_test2 = swap(~9, false) = (false, ~9)
val sum_two_pairs_test = sum_two_pairs((1, 2), (3, 4)) = 10
val sum_two_pairs_test2 = sum_two_pairs((123, 456), (789, 1)) = 1369
val div_mod_test = div_mod(7, 3) = (2, 1)
val div_mod_test2 = div_mod(100, 4) = (25, 0)
val sort_pair_test = sort_pair(100, 200) = (100, 200)
val sort_pair_test2 = sort_pair(200, 100) = (100, 200)