(* range in uncurried form *)
fun range (i,j) =
    if i=j
    then []
    else i :: range (i+1, j)


fun curry f x y = f(x,y)
fun uncurry f (x,y) = f x y

val countup = curry range 1
