(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw2provided.sml"; 

val test1a = all_except_option ("string", ["string"]) = SOME []
val test1b = all_except_option ("123", ["string"]) = NONE
val test1c = all_except_option ("a", ["a", "b", "c"]) = SOME ["b","c"]
val test1d = all_except_option ("a", ["b", "c"]) = NONE

val test2a = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test2b = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") 
           = ["Fredrick","Freddie","F"]
val test2c = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") 
           = ["Jeffrey","Geoff","Jeffrey"] 
 
val test3a = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test3b = get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") 
           = ["Fredrick","Freddie","F"]
val test3c = get_substitutions2([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") 
           = ["Jeffrey","Geoff","Jeffrey"] 

val test4a = similar_names ([["Fred","Fredrick"],
                             ["Elizabeth","Betty"],
                             ["Freddie","Fred","F"]], 
                             {first="Fred", middle="W", last="Smith"}) 
           = [{first="Fred", last="Smith", middle="W"},
              {first="Fredrick", last="Smith", middle="W"},
	           {first="Freddie", last="Smith", middle="W"}, 
              {first="F", last="Smith", middle="W"}]

val test4b = similar_names([["John","Johnathan"],
                            ["Elizabeth", "Betty"],
                            ["Jonathan", "John"]],
                            {first="John", middle="J", last="Doe"})
           = [{first="John", last="Doe", middle="J"},
              {first="Johnathan", last="Doe", middle="J"},
              {first="Jonathan", last="Doe", middle="J"}]

val test5a = card_color (Clubs, Num 2) = Black
val test5b = card_color (Spades, Jack) = Black
val test5c = card_color (Hearts, King) = Red
val test5d = card_color (Diamonds, Num 5) = Red

val test6a = card_value (Clubs, Num 2) = 2
val test6b = card_value (Spades, Queen) = 10
val test6c = card_value (Spades, King) = 10
val test6d = card_value (Hearts, Ace) = 11

val test7a = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [] 
val test7b = ((remove_card ([(Spades, Num 2)], (Hearts, Ace), IllegalMove); false) handle IllegalMove => true) 
val test7c = remove_card ([(Hearts, Ace), (Spades, Num 2)], (Hearts, Ace), IllegalMove) = [(Spades, Num 2)] 

val test8a = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8b = all_same_color [(Spades, Num 3), (Hearts, Num 2)] = false
val test8c = all_same_color [] = true
val test8d = all_same_color [(Clubs, Ace)] = true 

val test9a = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9b = sum_cards [(Spades, Jack), (Clubs, Ace)] = 21
val test9c = sum_cards [(Diamonds, Num 2), (Hearts, Queen)] = 12

val test10a = score ([(Hearts, Num 2),(Clubs, Num 4)], 10) = 4
val test10b = score ([(Hearts, Num 2),(Diamonds, Num 4)], 10) = 2
val test10c = score ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20) = 4
val test10d = score ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20) = 9

val test11a = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6 

val test11b = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw],
                        42)
            = 3

val test11c = ((officiate ([(Clubs,Jack),(Spades,Num(8))],
                              [Draw,Discard(Hearts,Jack)],
                              42);
                  false) 
                  handle IllegalMove => true)

(* val test12a = score_challenge ([(Hearts, Num 2),(Clubs, Num 4)], 10) = 4
val test12b = score_challenge ([(Hearts, Num 2),(Diamonds, Num 4)], 10) = 2
val test12c = score_challenge ([(Hearts, Ace),(Diamonds, Queen), (Hearts, Num 2)], 20) = 4
val test12d = score_challenge ([(Hearts, Ace),(Spades, Queen), (Hearts, Num 2)], 20) = 9 *)
             
