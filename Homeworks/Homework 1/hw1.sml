(* (int * int * int) * (int * int * int) -> bool *)
(* returns true if date1 is earlier than date2 *)
fun is_older (date1 : (int * int * int), date2 : (int * int * int)) =
    let
        val (y1,m1,d1) = date1
        val (y2,m2,d2) = date2
    in
        y1 < y2 
        orelse (y1=y2 andalso m1<m2) 
        orelse (y1=y2 andalso m1=m2 andalso d1<d2)
    end


(* (int * int * int) list * int -> int *)
(* returns how many dates in dl are in the given month m *)
fun number_in_month (dl:  (int * int * int) list, m : int) =
    if null dl
    then 0
    else if #2 (hd dl) = m
         then 1 + number_in_month (tl dl, m)
         else number_in_month (tl dl, m)


(* (int * int * int) list * int list -> int *)
(* returns the number of dates in the list of dates
   that are in any of the months in the list of months *)
fun number_in_months (dl : (int * int * int) list, ml : int list) =
    if null ml
    then 0
    else number_in_month (dl, hd ml) + number_in_months (dl, tl ml)


(* (int * int * int) list * int -> (int * int * int) list *)
(* returns the dates from the input date list that are in the input month *)
fun dates_in_month (dl : (int * int * int) list, m : int) =
    if null dl
    then []
    else
        if #2 (hd dl) = m
        then hd dl :: dates_in_month (tl dl, m)
        else dates_in_month (tl dl, m)


(* (int * int * int) list * int list -> (int * int * int) list *)
(* returns filtered input date list containing dates whose months are
in the input months list *)
fun dates_in_months (dl : (int * int * int) list, ml : int list) =
    if null ml
    then []
    else dates_in_month (dl, hd ml) @ dates_in_months (dl, tl ml)


(* string list * int -> string *)
(* returns the nth element of a string list *)
fun get_nth (sl : string list, n : int) =
    if n=1
    then hd sl
    else get_nth (tl sl, n-1)


(* (int * int * int) -> string *)
(* takes a date and returns astring of the form <M D, Y> (e.g. January 20, 2013) *)
fun date_to_string (d : (int * int * int)) =
    let
        val month_to_str = ["January",   "February", "March",    "April",
                            "May",       "June",     "July",     "August", 
                            "September", "October",  "November", "December"]
        val (y1,m1,d1) = d
    in
        get_nth (month_to_str, m1) ^ " " ^ Int.toString(d1) ^ ", " ^ Int.toString(y1) 
    end


(* int * int list -> int *)
(* return an int n such that the first n elements of the list add to
less than sum, but the first n+1 elements of the list add to sum or more *)

(* Solution raised by Kulemin Mikhail during peer review *)
fun number_before_reaching_sum (sum : int, il : int list) =
    if null il orelse sum <= hd il
    then 0
    else 1 + number_before_reaching_sum (sum - hd il, tl il)

(* Working alternative version with pattern matching and tail recursion: *)
(* fun number_before_reaching_sum (sum : int, il0 : int list) =
    let
        fun aux (il : int list, n : int, total : int) =
            case il of
                  [] => n
                | i::il' => if total+i >= sum
                            then n
                            else aux (il', n+1, total+i)
    in
        aux (il0, 0, 0)
    end *)


(* int -> int *)
(* takes a day of year (i.e., an int between 1 and 365) and returns
what month that day is in (1 for January, 2 for February, etc.). *)
fun what_month i : int =
    let
        val days_in_months = [31,28,31,30,31,30,31,31,30,31,30,31]
    in
        1 + number_before_reaching_sum (i, days_in_months)
    end


(* (int * int * int) * (int * int * int) -> int list *)
(* takes 2 ints and returns a list of all the months of the days between the day represented
by the 1st int and the day represented by the 2nd int
(inclusive of the months both dates are situated within) *)
fun month_range (day1 : int, day2 : int) =
    if day1 > day2
    then []
    else
        if day1 = day2
        then [what_month day2]
        else what_month day1 :: month_range (day1+1, day2)


(* (int * int * int) list -> (int * int * int) option *)
(* osf means oldest date so far *)
fun oldest (dl0 : (int * int * int) list) =
    if null dl0
    then NONE
    else
        let
            fun aux (dl : (int * int * int) list, osf : (int * int * int)) =
                if null dl
                then osf
                else
                    if osf = (0,0,0) orelse is_older (hd dl, osf)
                    then aux (tl dl, hd dl)
                    else aux (tl dl, osf)
        in
            SOME(aux (dl0, (0,0,0)))
        end


(* int list -> int list *)
(* removes duplicates from an input int list *)
fun remove_duplicates (xs : int list) =
    if null xs
    then []
    else
        let
            fun is_duplicate (i : int, ys : int list) =
            (* returns true if i has a duplicate in ys  *)
            (* int * int list -> bool *)
                if null ys
                then false
                else (i = hd ys) orelse is_duplicate (i, tl ys)
        in
            if is_duplicate (hd xs, tl xs)
            then remove_duplicates (tl xs)
            else hd xs :: remove_duplicates (tl xs)
        end
    

(* (int * int * int) list * int list -> int *)
(* returns the number of dates in the list of dates
   that are in any of the months in the list of months *)
fun number_in_months_challenge (dl : (int * int * int) list, ml : int list) =
    number_in_months (dl, remove_duplicates ml)


(* (int * int * int) list * int list -> (int * int * int) list *)
(* returns filtered input date list containing dates whose months are
in the input months list *)
fun dates_in_months_challenge (dl : (int * int * int) list, ml : int list) =
    dates_in_months (dl, remove_duplicates ml)


(* (int * int * int) -> bool *)
(* returns true if the input date is valid *)
fun reasonable_date (d : (int * int * int)) =
    let
        val (y1,m1,d1) = d

        fun days_in_the_month (m : int) =
            if m=2
            then if y1 mod 400 = 0 orelse (y1 mod 4 = 0 andalso y1 mod 100 <> 0)
                 then 29
                 else 28
            else if m=4 orelse m=6 orelse m=9 orelse m=11
                 then 30
                 else 31
    in
        y1 > 0 
        andalso ((1 <= m1) andalso (m1 <= 12))
        andalso ((1 <= d1) andalso (d1 <= (days_in_the_month m1)))
    end
