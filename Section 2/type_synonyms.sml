datatype suit = Club | Diamond | Heart | Spade

datatype rank = King | Queen | Jack | Ace
              | Num of int


(* Card is a type synonym for suit * rank *)
type card = suit * rank

val card1 : card = (Diamond, Num 3)
val card2 : suit * rank = (Club, Jack)
val card3 = (Spade, Queen)


 (* card -> bool *)
 (* returns true if the card is a queen of spades *)
fun is_Queen_Of_Spades (c : card) = 
    #1 c = Spade andalso #2 c = Queen 


val iqos_test1 = is_Queen_Of_Spades card1 = false
val iqos_test2 = is_Queen_Of_Spades card2 = false
val iqos_test3 = is_Queen_Of_Spades card3 = true


 (* card -> bool *)
 (* returns true if the card is a queen of spades *)
fun is_Queen_Of_Spades2 c =
    case c of
          (Spade, Queen) => true
        | _ => false

val iqos2_test1 = is_Queen_Of_Spades card1 = false
val iqos2_test2 = is_Queen_Of_Spades card2 = false
val iqos2_test3 = is_Queen_Of_Spades card3 = true
