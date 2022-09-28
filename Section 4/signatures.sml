signature MATHLIB =
sig

val fact : int -> int
val half_pi : real
val doubler : int -> int

end 


structure MyMathLib :> MATHLIB =
struct

fun fact x =
	if x=0
	then 0
	else x * fact(x-1)

val half_pi = Math.pi / 2.0

fun doubler x = x * 2 

end


val pi = MyMathLib.half_pi + MyMathLib.half_pi
val twentyeight = MyMathLib.doubler 14
