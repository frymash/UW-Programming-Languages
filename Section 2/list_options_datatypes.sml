datatype my_int_list = Empty
                     | Cons of int * my_int_list

val x = Cons (1, Cons (2, Cons (3, Empty)))
val y = Cons (4, Cons (5, Cons (6, Empty)))


(* my_int_list * my_int_list -> my_int_list *)
(* Appends ys to xs and returns the result *)
fun append_my_list (xs, ys) =
	case xs of
		  Empty => ys
		| Cons (x, xs') => Cons (x, append_my_list (xs', ys))

val test1 = append_my_list (x,y) = Cons (1, Cons (2, Cons (3, Cons (4, Cons (5, Cons (6, Empty))))))


(* 'a list * 'a list -> 'a list *)
(* implementation of append function *)
(* fun append (xs, ys) = 
    case xs of
          [] => ys
        | x :: xs' => x :: append (xs', ys) *)

(* Tail-recursive version *)
(* rsf is 'a list : represents the result accumulated so far
   in a given recursive call *)
fun append (xs0 : 'a list, ys0 : 'a list) =
    let
        fun reverse (lst : 'a list) =
            let
                fun reverse0 (xs : 'a list, rsf : 'a list) = 
                    case xs of
                         [] => rsf
                        | x :: xs' => reverse0 (xs', x :: rsf)
            in
                reverse0 (lst, [])
            end
        
        fun append0 (rev_xs : 'a list, rsf : 'a list) =
            case rev_xs of
                  [] => rsf
                | x :: rev_xs' => append0 (rev_xs', x :: rsf)
    in
        append0 (reverse(xs0), ys0)
    end


val test2 = append([1],[]) = [1]
val test3 = append([1,2,3],[4,5,6]) = [1,2,3,4,5,6]


(* int list -> int *)
(* returns the sum of elements in a list of integers xs *)
(* fun sum_list (xs) = 
    case xs of
          [] => 0
        | x :: xs' => x + sum_list(xs') *)

(* Tail-recursive version *)
(* acc is int : represents the sum so far in a given recursive call *)
fun sum_list (xs : int list) =
    let
        fun sum_list0 (xs : int list, acc : int) =
            case xs of
                  [] => acc
                | x :: xs' => sum_list0 (xs', x + acc)

    in
        sum_list0 (xs, 0)
    end


val test4 = sum_list([]) = 0
val test5 = sum_list([1,2,3,4,5]) = 15

(* val test6 = reverse ([1,2,3]) = [3,2,1]
val test7 = reverse ([56,74,21]) = [21,74,56] *)
