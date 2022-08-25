(* Dan Grossman, Coursera PL, HW2 Provided Code *)
(* Edited by ozervesh on Thursday, 25 August 2022 for submission *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)


(* string * string list -> string list option *)
(* Returns NONE if the input string is not in the input string list,
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
(* Returns a string list with all the strings that are in some list in subs that also has s,
   but s itself should not be in the result *)
fun get_substitutions1 (subs, s) =
   case subs of
        [] => []
      | xs::ys => case all_except_option (s, xs) of
                       NONE => get_substitutions1 (ys, s)
                     | SOME lst => lst @ get_substitutions1 (ys, s)


(* string list list * string -> string list *)
(* Tail-recursive version of get_substitutions1 *)
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


(* string list list * {first : string, middle : string, last : string} 
   -> {first : string, middle : string, last : string} list *)
(* Returns a list of full names (remember to pattern-match the arguments if necessary) *)
fun similar_names (subs, {first=f, middle=m, last=z}) =
   let
      val filtered_list = get_substitutions2 (subs, f) 
      fun convert_fn xs =
         case xs of
              [] => []
            | x::xs' => {first=x, middle=m, last=z} :: convert_fn (xs')
   in
      {first=f, middle=m, last=z} :: convert_fn (filtered_list)
   end


(* Recursive implementation with hashes (illegal for this assignment) *)
(* fun similar_names (subs, name) =
   let
      val filtered_list = get_substitutions2 (subs, #first name)

      (* string list -> {first : string, middle : string, last : string} list *)
      (* takes a list of first names and converts them into records with 'middle'
         and 'last' fields *)
      fun convert_fn xs =
         case xs of
              [] => []
            | x::xs' => {first=x, middle=(#middle name), last=(#last name)} :: convert_fn (xs')
   in
      name :: convert_fn (filtered_list)
   end *)

(* Tail-recursive version which I didn't use since append is involved *)
(* fun similar_names (subs, name) =
   let
      val filtered_list = get_substitutions2 (subs, #first name)
      fun aux (xs, acc) =
         case xs of
              [] => acc
            | x::xs' => aux (xs', acc @ [{first=x, middle=(#middle name), last=(#last name)}])
   in
      name :: aux (filtered_list, [])
   end *)
   

datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* card -> color *)
(* Returns the color of a given card *)
fun card_color (suit, rank) =
   case suit of
        Spades => Black
      | Clubs => Black
      | _ => Red


(* card -> int *)
(* Returns the value of a given card *)
fun card_value (suit, rank) =
   case rank of
        Num i => i
      | Ace => 11
      | _ => 10


(* card list * card * exn *)
(* Returns a list that has all the elements of cs except c.
   If c is in the list more than once, remove only the first one.
   Else, if c is not in the list, raise the exception e. *)
fun remove_card (cs, c, e) =
   case cs of
        [] => raise e
      | x::cs' => if x = c
                  then cs'
                  else x :: remove_card (cs', c, e)

(* Tail-recursive implementation which I didn't use since 
   a) append is involved and b) it's less intuitive *)
(* Something to think about: is it more computationally efficient to...
   a) use cons and reverse or
   b) use append? *)
(* fun remove_card (cs0, c, e) =
   let
      fun aux (cs, acc) =
         case cs of
              [] => raise e
            | x::cs' => if x = c
                        then acc @ cs'
                        else aux (cs', acc @ [x])
   in
      aux (cs0, [])
   end *)


(* card list -> bool *)
(* Returns true if all the cards in cs are of the same color *)
fun all_same_color cs =
   case cs of
        c1::c2::cs' => (card_color c1 = card_color c2) andalso all_same_color cs'
      | _ => true (* accounts for situations where cs has length 0 or 1 *)


(* card list -> int *)
(* Takes a list of cards and returns the sum of their values. Use a locally
   defined helper function that is tail recursive. *)
fun sum_cards cs =
   let
      fun aux (cs, acc) =
         case cs of
              [] => acc
            | c::cs' => aux (cs', (card_value c) + acc)
   in
      aux (cs, 0)
   end


(* card list * int -> int *)
(* returns the score of given card list based on a given goal *)
fun score (cs0, goal) =
   let
      fun sum cs =
         let
            fun aux (cs, acc) =
               case cs of
                    [] => acc
                  | c::cs' => aux (cs', (card_value c) + acc)
         in
            aux (cs0, 0)
         end
      
      fun prelim_score (s, g) =
         if s > g
         then 3 * (s - g)
         else g - s

      val hand_sum = sum cs0
   in
         if all_same_color cs0
         then prelim_score (hand_sum, goal) div 2
         else prelim_score (hand_sum, goal)     
   end


(* card list * move list * int -> int *)
(* Runs a solitaire game and returns the final score.
   The player begins with an empty hand [].
   cs is the cards in the draw pile,
   ms is the list of moves to be made,
   g is the goal, and hs is the card list in the player's hand *)

fun officiate (cs0, ms0, g) =
   let
      fun make_moves (cs, ms, g, hs) =
         let
            fun make_move (cs, m::ms', hs) =
               case m of
                    Discard x => make_moves (cs, ms', g, (remove_card (hs, x, IllegalMove)))
                  | Draw => case cs of
                                [] => raise IllegalMove
                              | c::cs' => make_moves (cs', ms', g, c::hs)
         in
            case ms of
                 [] => score (hs, g)
               | m::ms' => make_move (cs, m::ms', hs)
         end
   in
      make_moves (cs0, ms0, g, [])
   end
