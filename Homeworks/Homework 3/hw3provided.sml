(* provided code begins after this line *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
              | Unit
              | Tuple of valu list
              | Constructor of string * valu

(* (unit -> int) -> (string -> int) -> pattern -> int *)
fun g f1 f2 p =
    let 
	    val r = g f1 f2 
    in
        case p of
              Wildcard          => f1 ()
            | Variable x        => f2 x
            | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
            | ConstructorP(_,p) => r p
            | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	          | UnitT
	          | IntT
	          | TupleT of typ list
	          | Datatype of string

(* provided code ends here *)


(* string list -> string list *)
(* takes a string list and returns a string list that has only
   the strings in the argument that start with an uppercase letter *)
(* note: implementation of List.filter is curried, arguments cannot
   be passed as a tuple *)
fun only_capitals xs =
    List.filter (fn x => Char.isUpper(String.sub (x,0))) xs


(* string list -> string *)
(* takes a string list and returns the longest string in the list.
   If the list is empty, return "".
   In the case of a tie, return the string closest
   to the beginning of the list *)
fun longest_string1 xs =
    foldl (fn (i,j) => if String.size i > String.size j then i else j) "" xs


(* string list -> string *)
(* same functionality as longest_string1 except when
   in the case of a tie, return the string closest
   to the end of the list *)
fun longest_string2 xs =
    foldl (fn (i,j) => if String.size i >= String.size j then i else j) "" xs


(* (int * int -> bool) -> string list -> string *)
(* higher-order function to generate longest_string funcitons *)
val longest_string_helper = fn f : (int * int -> bool)
                          => fn xs : string list
                          => foldl (fn (i,j) => if f (String.size i, String.size j) then i else j) "" xs


(* string list -> string *)
(* Partial applications of longest_string_helper
   longest_string 3 mimics the behaviour of longest_string 1
   longest_string 4 mimics the behaviour of longest_string 2 *)
val longest_string3 = longest_string_helper (fn (i_size, j_size) => i_size > j_size)
val longest_string4 = longest_string_helper (fn (i_size,j_size) => i_size >= j_size)


(* string list -> string *)
(* takes a string list and returns the longest string in the list that begins
   with an uppercase letter, or "" if there are no such strings. *)
val longest_capitalized = longest_string1 o only_capitals


(* string -> string *)
(* takes a string and returns the string that is the same characters in
   reverse order *)
val rev_string = String.implode o List.rev o String.explode


(* ('a -> 'b option) -> 'a list -> 'b *)
(* The first argument should be applied to elements of the second argument in order
   until the first time it returns SOME v for some v
   and then v is the result of the call to first_answer.
   If the first argument returns NONE for all list elements,
   then first_answer should raise the exception NoAnswer.  *)
fun first_answer f xs = case xs of
                             [] => raise NoAnswer
                           | x::xs' => case f x of
                                            NONE => first_answer f xs'
                                          | SOME i => i


(* ('a -> 'b list option) -> 'a list -> 'b list option *)
(* The first argument should be applied to elements of the second
   argument. If it returns NONE for any element, then the result for all_answers is NONE. Else the
   calls to the first argument will have produced SOME lst1, SOME lst2, ... SOME lstn and the result of
   all_answers is SOME lst where lst is lst1, lst2, ..., lstn appended together (order doesn’t matter) *)
fun all_answers f xs =
   let
      fun aux f xs acc =
         case xs of
              [] => acc
            | x::xs' => case f x of
                             NONE => aux f xs' acc
                           | SOME lst => aux f xs' (acc @ lst)
   in
      case xs of
           [] => SOME []
         | x::xs' => case (aux f xs []) of
                          [] => NONE
                        | y::ys' => SOME (y::ys')
   end


(* pattern -> int *)
(* counts the number of wildcards in a pattern *)
fun count_wildcards p =
   g (fn x => 1) (fn y => 0) p

(* fun count_wildcards p =
   case p of
         Wildcard => 1
      |  TupleP ps => foldl (fn (p, acc) => (count_wildcards p) + acc) 0 ps
      |  ConstructorP (_, p) => count_wildcards p
      |  _ => 0 *)


(* pattern -> int *)
(* returns the number of Wildcard patterns it contains
   plus the sum of the string lengths of all the variables
   in the variable patterns it contains. *)
fun count_wild_and_variable_lengths p =
   (count_wildcards p) + (g (fn x => 0) (fn y => String.size y) p)


(* string * pattern -> int *)
(* takes a string and a pattern (as a pair) and
   returns the number of times the string appears
   as a variable in the pattern *)
fun count_some_var (s,p) = 
   g (fn x => 0) (fn y => if s = y then 1 else 0) p 


(* pattern -> bool *)
(* returns true if and only if all the variables
   appearing in the pattern are distinct from each other *)
fun check_pat p =
   let
      fun strings_in p =
         case p of
              Variable s => [s]
            | TupleP ps => foldl (fn (p,acc) => acc @ strings_in p) [] ps
            | ConstructorP (_,p) => strings_in p
            | _ => []

      fun all_distinct xs =
         (* can be reduced from polynomial time to linear time
            with a hashmap/dictionary *)
         case xs of
              [] => true
            | x::xs' => (List.exists (fn y => x=y) (x::xs')) andalso all_distinct xs'
   in
      (all_distinct o strings_in) p
   end


(* valu * pattern -> (string * valu) list option *)
(* returns NONE if the pattern does not match and SOME lst
   where lst is the list of bindings if it does.
   Note that if the value matches but the pattern
   has no patterns of the form Variable s, then the result
   is SOME [] *)
fun match v p =
   case (v,p) of
        (Constructor (s1,v1), ConstructorP (s2,p1) ) => match v1 p1
      | (Tuple vs, TupleP ps) => SOME [...]
      | (Const i1, ConstP i2) => if i1=i2 then SOME [] else NONE
      | (v1, Variable s) => SOME [(s, v1)]
      | (Unit, UnitP) => SOME []
      | (_, Wildcard) => SOME []
      | (_, _) => NONE


