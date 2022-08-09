(* This is a comment. This is our first program. *)

val x = 34;
(* Static environment: x: int *)
(* Dynamic environment: x --> 34 *)

val y = 17;
(* Static environment: x: int, y: int *)
(* Dynamic environment: x--> 34, y --> 17 *)

val z = (x + y) + (y + 2);
(* Static environment: x: int, y: int, z: int *)
(* Dynamic environment: x --> 34,
                        y --> 17,
                        z --> (34 + 17) + (17 + 2) --> 51 + 19 --> 70 *)

val q = z + 1;
(* Static environment: x: int, y: int, z: int, q: int *)
(* Dynamic environment: x --> 34,
                        y --> 17,
                        z --> (34 + 17) + (17 + 2) --> 51 + 19 --> 70
                        q --> (70 + 1) --> 71 *)

val abs_of_z = if z < 0 then ~z else z;
(* Static environment: x: int, y: int, z: int, q: int, abs_of_z: int *)
(* Dynamic environment: x --> 34,
                        y --> 17,
                        z --> (34 + 17) + (17 + 2) --> 51 + 19 --> 70
                        q --> (70 + 1) --> 71
                        abs_of_z --> 70 *)

val abs_of_z_simpler = abs z;
(* Static environment: x: int, y: int, z: int, q: int, abs_of_z: int, abs_of_z_simpler: int *)
(* Dynamic environment: x --> 34,
                        y --> 17,
                        z --> (34 + 17) + (17 + 2) --> 51 + 19 --> 70
                        q --> (70 + 1) --> 71
                        abs_of_z --> 70
                        abs_of_z_simpler --> 70 *)
