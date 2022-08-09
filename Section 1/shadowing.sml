(* For the video on shadowing *)

val a = 1
(* Dynamic environment: a --> 1 *)

val b = 2
(* Dynamic environment: a --> 1, b --> 2 *)

val a = 5
(* Dynamic environment: a --> 5, b --> 2 *)

val c = 100
(* Dynamic environment: a --> 5, b --> 2, c --> 100 *)

val c = c + b
(* Dynamic environment: a --> 5, b --> 2, c --> 102 *)

val a = a + 10
(* Dynamic environment: a --> 15, b --> 2, c --> 102 *)