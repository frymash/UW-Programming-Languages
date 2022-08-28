(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw2.sml";

val all_except_option_test1 = all_except_option ("string", ["string"]) = SOME []
val all_except_option_test2 = all_except_option ("123", ["string"]) = NONE
val all_except_option_test3 = all_except_option ("a", ["a", "b", "c"]) = SOME ["b","c"]
val all_except_option_test4 = all_except_option ("a", ["b", "c"]) = NONE

val get_substitutions1_test1 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val get_substitutions1_test2 = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") 
           = ["Fredrick","Freddie","F"]
val get_substitutions1_test3 = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") 
           = ["Jeffrey","Geoff","Jeffrey"] 
 
val get_substitutions2_test1 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val get_substitutions2_test2 = get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") 
           = ["Fredrick","Freddie","F"]
val get_substitutions2_test3 = get_substitutions2([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") 
           = ["Jeffrey","Geoff","Jeffrey"] 

val similar_names_test1 = similar_names ([["Fred","Fredrick"],
                             ["Elizabeth","Betty"],
                             ["Freddie","Fred","F"]], 
                             {first="Fred", middle="W", last="Smith"}) 
           = [{first="Fred", last="Smith", middle="W"},
              {first="Fredrick", last="Smith", middle="W"},
	           {first="Freddie", last="Smith", middle="W"}, 
              {first="F", last="Smith", middle="W"}]

val similar_names_test2 = similar_names([["John","Johnathan"],
                            ["Elizabeth", "Betty"],
                            ["Jonathan", "John"]],
                            {first="John", middle="J", last="Doe"})
           = [{first="John", last="Doe", middle="J"},
              {first="Johnathan", last="Doe", middle="J"},
              {first="Jonathan", last="Doe", middle="J"}]

val card_color_test1 = card_color (Clubs, Num 2) = Black
val card_color_test2 = card_color (Spades, Jack) = Black
val card_color_test3 = card_color (Hearts, King) = Red
val card_color_test4 = card_color (Diamonds, Num 5) = Red

val card_value_test1 = card_value (Clubs, Num 2) = 2
val card_value_test2 = card_value (Spades, Queen) = 10
val card_value_test3 = card_value (Spades, King) = 10
val card_value_test4 = card_value (Hearts, Ace) = 11

val remove_card_test1 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [] 
val remove_card_test2 = ((remove_card ([(Spades, Num 2)], (Hearts, Ace), IllegalMove); false) handle IllegalMove => true) 
val remove_card_test3 = remove_card ([(Hearts, Ace), (Spades, Num 2)], (Hearts, Ace), IllegalMove) = [(Spades, Num 2)] 

val all_same_color_test1 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val all_same_color_test2 = all_same_color [(Spades, Num 3), (Hearts, Num 2)] = false
val all_same_color_test3 = all_same_color [] = true
val all_same_color_test4 = all_same_color [(Clubs, Ace)] = true 
val all_same_color_test5 = all_same_color [(Clubs,Ace),(Spades,Ace),(Diamonds,Ace)] = false

val sum_cards_test1 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val sum_cards_test2 = sum_cards [(Spades, Jack), (Clubs, Ace)] = 21
val sum_cards_test3 = sum_cards [(Diamonds, Num 2), (Hearts, Queen)] = 12

val score_test1 = score ([(Hearts, Num 2),(Clubs, Num 4)], 10) = 4
val score_test2 = score ([(Hearts, Num 2),(Diamonds, Num 4)], 10) = 2
val score_test3 = score ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20) = 4
val score_test4 = score ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20) = 9

val officiate_test1 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6 

(* game ends with no more moves and the held-cards are of the same colour *)
val officiate_test2 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw],
                        42)
            = 3

(* game ends with no more moves and the held-cards are of different colors *)
val officiate_test3 = officiate ([(Clubs, Ace), (Diamonds, Ace), (Clubs, Ace)], [Draw,Draw,Draw], 30)
                    = 9

(* throw IllegalMove when a card that is not in the player's hand is called to be discarded *)
val officiate_test4 = ((officiate ([(Clubs,Jack),(Spades,Num(8))],
                                   [Draw,Discard(Hearts,Jack)],
                                   42);
                  false) 
                  handle IllegalMove => true)

(* game ends when sum of cards in hand > goal *)
val officiate_test5 = officiate ([(Hearts, Num 2),(Spades, Queen),(Spades, Num 4)],[Draw,Draw],5) = 21

(* game starts with empty card list *)
val officiate_test6 = officiate ([],[Draw,Draw,Draw], 5) = 2

(* val ace_score_test1 = ace_score ([(Hearts, Num 2),(Clubs, Num 4)], 10, 0) = 4
val ace_score_test2 = ace_score ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20, 0) = 4
val ace_score_test3 = ace_score ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20, 1) = 3
val ace_score_test4 = ace_score ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20, 0) = 9
val ace_score_test5 = ace_score ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20, 1) = 7
val ace_score_test6 = ace_score ([(Hearts, Ace),(Spades, Queen), (Hearts, Ace)], 40, 2) = 28
val ace_score_test7 = ace_score ([(Hearts, Ace),(Spades, Queen), (Hearts, Ace)], 40, 1) = 18
val ace_score_test8 = ace_score ([(Hearts, Ace),(Spades, Queen), (Hearts, Ace)], 40, 0) = 8 *) 

val score_challenge_test1 = score_challenge ([(Hearts, Num 2),(Clubs, Num 4)], 10) = 4
val score_challenge_test2 = score_challenge ([(Hearts, Num 2),(Diamonds, Num 4)], 10) = 2
val score_challenge_test3 = score_challenge ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20) = 3
val score_challenge_test4 = score_challenge ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20) = 7
val score_challenge_test5 = score_challenge ([(Hearts, Ace),(Spades, Queen), (Hearts, Ace)], 40) = 8 

val officiate_challenge_test1 = officiate_challenge ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6 
val officiate_challenge_test2 = officiate_challenge ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                                           [Draw,Draw,Draw,Draw],
                                           42)
                              = 3
val officiate_challenge_test3 = officiate_challenge ([(Clubs, Ace), (Diamonds, Ace), (Clubs, Ace)], [Draw,Draw,Draw], 30)
                              = 7
val officiate_challenge_test4 = ((officiate_challenge ([(Clubs,Jack),(Spades,Num(8))],
                                   [Draw,Discard(Hearts,Jack)],
                                   42);
                                  false) 
                              handle IllegalMove => true)
val officiate_challenge_test5 = officiate_challenge ([],[Draw,Draw,Draw], 5) = 2 


val careful_player_test1 = careful_player ([], 5) = []
(* val careful_player_test2 = careful_player ([], 10) handle DrawError => true *)
val careful_player_test3 = careful_player ([(Hearts, Num 2),(Clubs, Num 4)], 10) = []

(* Value of held cards never exceed the goal. In test 4, the 1st draw brings the value of the held cards
   up to 11. If a 2nd draw is made, the value of the held cards would become 21. Hence, no further
   draws should be made. *)
val careful_player_test4 = careful_player ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20)
                         = [Draw]

(* val_careful_player_test5 *) 
