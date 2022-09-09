val cbs : (int -> unit) list ref = ref []

(* (int -> unit) -> unit *)
(* stacks functions in cbs (callback stack) to call later *)
(* in other words, this function registers new callbacks to be
   executed later *)
fun onKeyEvent f = cbs := f::(!cbs)

(* int -> unit *)
(* passes i : int (a key that has just been "pressed")
   to all the callbacks in cbs *)
fun onEvent i =
    let
      fun loop fs =
        case fs of
              [] => ()
            | f::fs' => (f i; loop fs') 
    in
      loop (!cbs)
    end

(* counts the number of times a "key" has been pressed *)
val timesPressed = ref 0
val _ = onKeyEvent (fn _ => timesPressed := (!timesPressed) + 1)

(* int -> unit *)
(* prints a line if an input i is equal to the key that was pressed
   (which the private variable j refers to in this case) *)
fun printIfPressed i =
    onKeyEvent (fn j =>
        if i=j
        then print ("You pressed " ^ Int.toString i ^ "\n")
        else ())

(* callbacks that simulate the "pressing" of certain keys *)
val _ = printIfPressed 4
val _ = printIfPressed 11
val _ = printIfPressed 23
val _ = printIfPressed 4

(* Running the program and typing "onEvent 4;" in the console
   will produce the output "You pressed 4 (newline) You pressed 4".
   "!timesPressed;" will show that its reference has been mutated to 1. *)

(* If you run "onEvent n;" where n is a number that isn't in the callback
   stack (i.e. 4, 11, or 23 in this code snippet), the compiler will
   not return any output. *)
