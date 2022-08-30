(* A naive implementation of several functions. *)

fun increment_n_times_lame (n,x) =
    if n=0
    then x
    else 1 + increment_n_times_lame (n-1, x)


fun double_n_times_lame (n,x) =
    if n=0
    then x
    else 2 * double_n_times_lame (n-1, x)

fun nth_tail_lame (n,xs) =
    if n=0
    then xs
    else tl (nth_tail_lame (n-1, xs))


(* We can create a higher-order function that
    a. extracts the common structure of the 3 functions above and
    b. is able to replicate the functionality of the functions above
       through the use of first-class functions as arguments. *)

(* ('a -> 'a) * int * 'a -> 'a *)
(* applies a function f to x n times *)
fun n_times (f,n,x) =
    if n=0
    then x
    else f (n_times (f, n-1, x))

fun incr x = x + 1
fun double x = x + x

fun addition (n,x) = n_times (incr,n,x)
fun double_n_times (n,x) = n_times (double,n,x)
fun nth_tail (n,xs) = n_times (tail,n,xs)

val incr_test = increment_n_times_lame (5, 5) = n_times (incr, 5, 5)
val double_test = double_n_times_lame (2,5) = n_times (double, 2, 5)
val tl_test = nth_tail_lame (2, [1,2,3,4,5]) = n_times (tl, 2, [1,2,3,4,5]) (* [3,4,5] *)