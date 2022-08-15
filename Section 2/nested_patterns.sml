exception ListLengthMismatch


(* Bad implementation of zip - conditional statement with 
too many branches *)
fun old_zip3 (l1,l2,l3) = 
    if null l1 andalso null l2 andalso null l3
    then []
    else if null l1 orelse null l2 orelse null l3
    then raise ListLengthMismatch
    else (hd l1, hd l2, hd l3) :: old_zip3(tl l1, tl l2, tl l3)


(* Bad implementation of zip - case expression that has so many
nested case expressions that it becomes very unreadable *)
fun shallow_zip3 (l1,l2,l3) =
    case l1 of
			[] => 
				(case l2 of 
				     [] => (case l3 of
												[] => []
									     | _ => raise ListLengthMismatch)
						| _ => raise ListLengthMismatch)
  | hd1::tl1 => 
			(case l2 of
			     [] => raise ListLengthMismatch
			   | hd2::tl2 => (case l3 of
										      [] => raise ListLengthMismatch
										    | hd3::tl3 => 
										      (hd1,hd2,hd3)::shallow_zip3(tl1,tl2,tl3)))


(* Good implementation of zip - uses nested patterns *)
(* ('a list * 'b list * 'c list) -> ('a * 'b * 'c) list *)
(* zips a 3-tuple of lists *)
fun zip3 list_triple =
	case list_triple of
		  ([],[],[]) => []
		| (a::tl1, b::tl2, c::tl3) => (a,b,c)::zip3(tl1,tl2,tl3)
		| _ => raise ListLengthMismatch


val test1 = zip3 ([1,2,3],[4,5,6],[7,8,9]) = [(1,4,7), (2,5,8), (3,6,9)]


(* ('a * 'b * 'c) list -> ('a list * 'c list * 'c list) *)
(* unzips a list of triples *)
fun unzip3 triple_list =
	case triple_list of
		  [] => ([],[],[])
		| (a,b,c)::tl1 => let val (l1,l2,l3) = unzip3 tl1
											in (a::l1, b::l2, c::l3)
											end

val test2 = unzip3 [(1,4,7), (2,5,8), (3,6,9)] = ([1,2,3],[4,5,6],[7,8,9])