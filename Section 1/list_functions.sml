(* int list ->  int *)
(* returns the sum of all elements in an int list *)
fun sum_list(xs : int list) =
	if null xs
	then 0
	else (hd xs) + sum_list(tl xs)


(* int -> int list *)
(* creates an int list that counts down from the input number to 0 *)
fun countdown(x : int) =
	if x = 0
	then []
	else x :: countdown(x - 1)


(* ('a list) * ('a list) -> 'a list *)
(* appends the 2nd input list onto the 1st input list *)
fun append(xs : 'a list, ys : 'a list) =
	if null xs
	then ys
	else (hd xs) :: append((tl xs), ys)


(* (int * int) list -> int *)
(* sums all elements in an (int * int) list *)
fun sum_pair_list(xs : (int * int) list) =
	if null xs
	then 0
	else #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs)


(* (int * int) list -> int list *)
(* returns a list of the 1st elements from every pair in a list of (int * int) pairs *)
fun firsts(xs : (int * int) list) = 
	if null xs
	then []
	else #1 (hd xs) :: firsts(tl xs)


(* (int * int) list -> int list *)
(* returns a list of the 2nd elements from every pair in a list of (int * int) pairs *)
fun seconds(xs : (int * int) list) = 
	if null xs
	then []
	else #2 (hd xs) :: seconds(tl xs)


(* (int * int) list -> int *)
(* sums all elements in an (int * int) list *)
fun sum_pair_list2(xs : (int * int) list) =
	(sum_list(firsts(xs))) + (sum_list(seconds(xs)))