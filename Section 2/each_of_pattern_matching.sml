(* 3 variants of a function that sums the elements of a triple *)
(* (int * int * int) -> int *)

(* Bad style - using a 1-branched case expression *)
fun bad_triple triple =
    case triple of
        (x, y, z) => x + y + z


(* Decent style - using a let expression *)
fun decent_triple triple =
    let
        val (x, y, z) = triple
    in
        x + y + z
    end


(* Good style - pattern matching function parameters *)
fun good_triple (x, y, z) =
    x + y + z


(* Tests *)
val bt_test1 = bad_triple (1,2,3) = 6
val dt_test1 = decent_triple (1,2,3) = 6
val gt_test1 = good_triple (1,2,3) = 6


(* 3 variants of a function that concats the first, middle, and
last names of a student. *)
(* {first : string, middle : string, last : string} -> string *)

(* Bad style - using a 1-branched conditional *)
fun bad_fullname r =
    case r of
        {first=x, middle=y, last=z} => x ^ " " ^ y ^ " " ^ z


(* Decent style - using a let expression *)
fun decent_fullname r =
    let
        val {first=x, middle=y, last=z} = r
    in
        x ^ " " ^ y ^ " " ^ z
    end


(* Good style - pattern matching function parameters *)
fun good_fullname {first=x, middle=y, last=z} =
    x ^ " " ^ y ^ " " ^ z


(* Tests *)
val bf_test1 = bad_fullname {first="Tan", middle="Ah", last="Kow"} = "Tan Ah Kow"
val df_test1 = decent_fullname {first="Tan", middle="Ah", last="Kow"} = "Tan Ah Kow"
val gf_test1 = good_fullname {first="Tan", middle="Ah", last="Kow"} = "Tan Ah Kow"
