fun pow(x: int, y: int) =
(* returns the value of x^y *)
(* only works if y >= 0, otherwise it'll run infinitely *)
	if y = 0
	then 1
	else x * pow(x, y-1)