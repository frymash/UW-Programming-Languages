(* This code should throw an exception. *)
(* val r = ref NONE (* val r : 'a option ref *)
val _ = r := SOME "hi"
val i = 1 + valOf (!r) *)

(* type 'a foo = 'a ref
val f = ref
val r = f NONE *)

val pairWithOne = List.map (fn x => (x,1))