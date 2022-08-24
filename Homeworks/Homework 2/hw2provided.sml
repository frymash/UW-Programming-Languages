(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)


(* string * string list -> string list option *)
(* returns NONE if the input string is not in the input string list,
else return SOME lst where lst is identical to the argument list except the string
is not in it.*)
fun all_except_option (s, xs0) =
   let
     fun all_except xs =
         case xs of  
               [] => []
             | x::xs' => if same_string (x, s)
                         then all_except xs'
                         else x :: all_except xs'

      val filtered_list = all_except xs0
   in
      if filtered_list = xs0
      then NONE
      else SOME filtered_list
   end


(* string list list * string -> string list *)
(* returns a string list with all the strings that are in some list in subs that also has s,
   but s itself should not be in the result *)
fun get_substitutions1 (subs, s) =
   case subs of
        [] => []
      | xs::ys => case all_except_option (s, xs) of
                       NONE => get_substitutions1 (ys, s)
                     | SOME lst => lst @ get_substitutions1 (ys, s)


(* string list list * string -> string list *)
(* tail-recursive version of get_substitutions1 *)
fun get_substitutions2 (subs0, s) =
   let
      fun aux (subs, acc) =
         case subs of
              [] => acc
            | xs::ys => case all_except_option (s, xs) of
                             NONE => aux (ys, acc)
                           | SOME lst => aux (ys, acc @ lst)

   in
      aux (subs0, [])
   end


(* (d) Write a function similar_names, which takes a string list list of substitutions (as in parts (b) and
      (c)) and a full name of type {first:string,middle:string,last:string} and returns a list of full
      names (type {first:string,middle:string,last:string} list). 
      
      The result is all the full names you can produce by substituting for the first name (and only the first name)
      using substitutions and parts (b) or (c). The answer should begin with the original name
      (then have 0 or more other names).
      
      Do not eliminate duplicates from the answer. Hint: Use a local helper function. Sample solution is around 10 lines. *)

(* string list list * {first : string, middle : string, last : string} -> {first : string, middle : string, last : string} list *)
(* fun similar_names (sll, name) =
   [{first="",middle="",end=""}] *)


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
