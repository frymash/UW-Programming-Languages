fun add1 (x : int) = 
    let 
        val y = 1
    in 
        x + y
    end

(* Nested let expression *)
(* Should return int 7 *)
fun silly () =
    let 
        val x = 1
    in
        (let val x = 2 in x + 1 end) + (let val y = x + 2 in y + 1 end)
    end