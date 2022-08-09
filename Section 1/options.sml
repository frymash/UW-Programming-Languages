(* max function without options *)
(* int list -> int *)
fun good_max (xs : int list) =
	if null xs
	then 0 (* horrible style, but we'll fix it in the next section *)
	else if null (tl xs)
	then hd xs
	else 
		let val tl_max = good_max (tl xs)
		in
			if hd xs > tl_max
			then hd xs
			else tl_max
		end


(* 1st max function with options *)
(* int list -> int option *)
fun max1 (xs : int list) =
	if null xs
	then NONE
	else
		let val tl_max = max1 (tl xs)
		in if isSome tl_max andalso valOf tl_max > hd xs
			 then tl_max
			 else SOME (hd xs)
		end


(* 2nd max function with options *)
(* int list -> int option *)
fun max2 (xs : int list) =
	if null xs
	then NONE
	else (* at this point, we can guarantee xs is nonempty *)
		let
            fun max_nonempty (xs : int list) = 
                if null (tl xs) (* assuming xs is nonempty*)
                then hd xs
                else let val tl_max = max_nonempty (tl xs)
                     in
                        if hd xs > tl_max
                        then hd xs
                        else tl_max
                     end
         in
            SOME (max_nonempty xs)
         end