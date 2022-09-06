val x = 1
fun f y =
    let
        val x = y + 1
    in
        fn z => x + y + z
    end
val x = "hi"
val g = f 7
val z = g 4