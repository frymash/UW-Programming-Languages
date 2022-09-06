(* ('a * 'b-> 'a) * 'a * 'b list -> 'a *)
(* fold function that traverses from left to right *)
fun foldl (f, acc, xs) =
    case xs of
          [] => acc
        | x::xs' => foldl (f, f(acc,x), xs')

(* int list -> int *)
(* sums all the elements in a given list *)
fun sum_list xs =
    foldl (fn (x,y) => x+y, 0, xs)


(* int list -> bool *)
(* returns true if all integers in an int list are non-negative *)
fun all_non_negative xs =
    foldl (fn (acc, x) => acc andalso x > 0, true, xs)


(* int list * int * int -> int *)
(* returns the number of elements in xs that fall between lo and hi *)
fun between_lo_and_hi (xs, lo, hi) =
    foldl (fn (acc, x) => acc + (if lo <= x andalso x <= hi then 1 else 0), 0, xs)


(* string list * string -> bool *)
(* returns true if all strings in xs are shorter in length than string s *)
fun all_shorter_than_s (xs,s) =
    let
        val i = String.size s
    in
        foldl (fn (acc, x) => acc andalso String.size x < i , true, xs)
    end

(* ('a -> bool) * 'a list -> bool *)
(* returns true if all elements in the list produce true under function g *)
fun all_true_under_func (g, xs) =
    foldl (fn (acc, x) => acc andalso g x, true, xs)


(* string list * string -> bool *)
(* implementation of all_shorter_than_s with the use of all_true_under_func *)
fun all_shorter_than_s_v2 (xs,s) =
    let
        val i = String.size s
    in
        all_true_under_func (fn x => String.size x < i, xs)
    end


val sum_list_test1 = sum_list ([1,2,3,4,5]) = 15
val sum_list_test2 = sum_list ([10,20,30]) = 60
val sum_list_test3 = sum_list ([]) = 0
val sum_list_test4 = sum_list ([1]) = 1

val all_non_negative_test1 = all_non_negative ([]) = true
val all_non_negative_test2 = all_non_negative ([1]) = true
val all_non_negative_test3 = all_non_negative ([~1]) = false
val all_non_negative_test4 = all_non_negative ([1,4,~5,6]) = false
val all_non_negative_test5 = all_non_negative ([1,4,5,6]) = true

val between_lo_and_hi_test1 = between_lo_and_hi ([],1,2) = 0
val between_lo_and_hi_test2 = between_lo_and_hi ([1,2,3,4,5],1,5) = 5
val between_lo_and_hi_test3 = between_lo_and_hi ([1,3,5,7],1,3) = 2

val all_shorter_than_s_test1 = all_shorter_than_s ([], "") = true
val all_shorter_than_s_test2 = all_shorter_than_s ([""], "") = false
val all_shorter_than_s_test3 = all_shorter_than_s ([""], "_") = true
val all_shorter_than_s_test4 = all_shorter_than_s (["a", "b","c"], "bob") = true
val all_shorter_than_s_test5 = all_shorter_than_s (["bobby", "b","c"], "bob") = false

val all_shorter_than_s_v2_test1 = all_shorter_than_s_v2 ([], "") = true
val all_shorter_than_s_v2_test2 = all_shorter_than_s_v2 ([""], "") = false
val all_shorter_than_s_v2_test3 = all_shorter_than_s_v2 ([""], "_") = true
val all_shorter_than_s_v2_test4 = all_shorter_than_s_v2 (["a", "b","c"], "bob") = true
val all_shorter_than_s_v2_test5 = all_shorter_than_s_v2 (["bobby", "b","c"], "bob") = false
