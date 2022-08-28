(* Provided function *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2


(* Code for problem 1 begins after this line *)


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
   

(* Code for problem 2 begins after this line *)


datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove
exception DrawError


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


(* card list * card * exn -> card list *)
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
        c1::c2::cs' => (card_color c1 = card_color c2) andalso all_same_color (c2::cs')
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


(* int * int -> int *)
(* helper function to calculate preliminary score in score and ace_score *)
fun prelim_score (s, g) =
   if s > g
   then 3 * (s - g)
   else g - s


(* card list * int * int -> int *)
(* returns the score of a given card list based on a goal
   and the sum of the card list *)
fun score_general (cs, goal, hand_sum) =
   if all_same_color cs
   then prelim_score (hand_sum, goal) div 2
   else prelim_score (hand_sum, goal)    


(* card list * int -> int *)
(* returns the score of given card list based on a given goal *)
fun score (cs, goal) =
   score_general (cs, goal, sum_cards cs)


(* card list * move list * int * (card list * int -> int) -> int *)
(* Runs a solitaire game and returns the final score.
   The player begins with an empty hand [].
   cs is the cards in the draw pile,
   ms is the list of moves to be made,
   g is the goal, and hs is the card list in the player's hand
   f is the function that generates a score for the hand *)
fun officiate_general (cs0, ms0, g, f) =
   let
      fun advance_game (cs, ms, hs) =
         let
            fun make_move (cs, m::ms', hs) =
               case m of
                    Discard x => advance_game (cs, ms', (remove_card (hs, x, IllegalMove)))
                  | _ => case cs of
                             [] => f (hs, g)
                           | c::cs' => advance_game (cs', ms', c::hs)
         in
            case ms of
                 [] => f (hs, g)
               | m::ms' => if sum_cards hs > g
                           then f (hs, g)
                           else make_move (cs, m::ms', hs)
         end
   in
      advance_game (cs0, ms0, [])
   end


(* card list * move list * int -> int *)
(* returns the score of a solitaire game based on a draw pile (card list),
   move list, a goal, and the standard score function *)
fun officiate (cs, ms, g) =
   officiate_general (cs, ms, g, score)


(* card list * int -> int *)
(* returns the lowest possible score in a card list if Ace can take a value
   of either 1 or 11 *)
fun score_challenge (cs, goal) =
   let
      val original_score = score (cs, goal)

      (* card list -> int *)
      (* counts the number of aces in a list *)
      fun count_aces cs0 =
         let
            fun aux (cs, acc) =
               case cs of
                  [] => acc
                  | (s,r)::cs' => if r = Ace
                                 then aux (cs', 1 + acc)
                                 else aux (cs', acc)
         in
            aux (cs0, 0)
         end

      (* card list * int * int -> int *)
      (* returns the score of a card list given a = no. of aces that take the value
         of 1 and not 11 *)
      fun ace_score (cs0, goal, one_point_aces) =
         let
            fun sum_cards_ace (cs, one_point_aces) =
               sum_cards cs - (10 * one_point_aces)
         in
            score_general (cs0, goal, sum_cards_ace (cs0, one_point_aces))   
         end

      (* card list * int * int * int -> int *)
      (* returns the lowest possible score based on the card list, goal,
         lowest score so far (lsf), and the number of 1-point aces
         in a card list *)
      fun find_lowest_score (cs, goal, lsf, one_point_aces) =
         case one_point_aces of
              0 => lsf
            | _ => let
                     val curr = ace_score (cs, goal, one_point_aces)
                  in
                     if curr < lsf
                     then find_lowest_score (cs, goal, curr , one_point_aces - 1)
                     else find_lowest_score (cs, goal, lsf, one_point_aces - 1)
                  end
   in
      find_lowest_score (cs, goal, original_score, count_aces cs)
   end


(* card list * move list * int -> int *)
(* returns the score of a solitaire game based on a draw pile (card list),
   move list, a goal, and the challenge score function *)
fun officiate_challenge (cs, ms, g) =
   officiate_general (cs, ms, g, score_challenge)


(* card list * int -> move list *)
(* generates a move list such that whenever officiate (cs, ms, g) is called,
   the move list must have the following behaviour: 
   1. The value of the held cards never exceeds the goal.
   2. A card is drawn whenever the goal is more than 10 greater than the value of the held cards. As a
      detail, you should (attempt to) draw, even if no cards remain in the card-list.
   3. If a score of 0 is reached, there must be no more moves.
   4. If it is possible to reach a score of 0 by discarding a card followed by drawing a card,
      it must be done *)
fun careful_player (cs, g) =
   let
      fun aux (cs, g, hs, acc) =
         let
            val held_value = sum_cards hs
         in
            case (cs, hs) of
                 ([], _) => acc
               | (c::cs', []) => if g - held_value > 10
                                 then aux (cs', g, (c::hs), acc @ [Draw])
                                 else acc
               | (c::cs', h::hs') => if held_value + card_value c > g orelse score ((h::hs'), g) = 0
                                     then acc
                                     else
                                       if score (c::hs', g) = 0
                                       then aux (cs', g, (c::hs'), acc @ [Discard h, Draw]) 
                                       else
                                          if g - held_value > 10
                                          then aux (cs', g, (c::h::hs'), acc @ [Draw])
                                          else acc
         end
   in
      aux (cs, g, [], [])
   end
