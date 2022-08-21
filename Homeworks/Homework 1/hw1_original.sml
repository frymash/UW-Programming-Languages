(* Date is (int * int * int)
    - 1st int is the year (any positive int)
    - 2nd int is the month (1-12)
    - 3rd int is the day (1-31) *)
type date = int * int * int


(* 1. Write a function is_older that takes two dates and evaluates to true or false. It evaluates to true if
the first argument is a date that comes before the second argument. (If the two dates are the same,
the result is false.) *)

(* date * date -> bool *)
(* returns true if date1 is earlier than date2 *)
fun is_older (date1 : date, date2 : date) =
    let
      val (y1,m1,d1) = date1
      val (y2,m2,d2) = date2
    in
        y1 < y2 orelse (y1=y2 andalso (m1<m2 orelse (m1=m2 andalso d1<d2)))
    end

    
    (* in
      if y1 < y2
      then true
      else if y1 = y2
           then if m1 < m2
                then true
                else if m1 = m2
                     then if d1 < d2
                          then true
                          else false
                     else false
           else false
    end *)


(* 2. Write a function number_in_month that takes a list of dates and a month (i.e., an int) and returns
how many dates in the list are in the given month. *)

(* date list * int -> int *)
(* returns how many dates in dl are in the given month m *)
fun number_in_month (dl:  date list, m : int) =
    if null dl
    then 0
    else if #2 (hd dl) = m
         then 1 + number_in_month (tl dl, m)
         else number_in_month (tl dl, m)

(* Working alternative version with pattern matching and tail recursion: *)
(* fun number_in_month (dl0 : date list, m: int) =
    let
        fun aux (dl, acc) =
            case dl of
                  [] => acc
                | ((d1,m1,y1)::dl') => if m1 = m
                                       then aux (dl', acc+1)
                                       else aux (dl', acc)
    in
        aux (dl0, 0)
    end *)


(* 3. Write a function number_in_months that takes a list of dates and a list of months (i.e., an int list)
and returns the number of dates in the list of dates that are in any of the months in the list of months.
Assume the list of months has no number repeated. Hint: Use your answer to the previous problem. *)

(* date list * int list -> int *)
(* returns the number of dates in the list of dates
   that are in any of the months in the list of months *)
fun number_in_months (dl : date list, ml : int list) =
    if null ml
    then 0
    else number_in_month (dl, hd ml) + number_in_months (dl, tl ml)


(* Working alternative version with pattern matching: *)
(* fun number_in_months (dl: date list, ml: int list) =
    case ml of
          [] => 0  
        | m::ml' => number_in_month (dl, m)
                    + number_in_months (dl, ml') *)


(* 4. Write a function dates_in_month that takes a list of dates and a month (i.e., an int) and returns a
list holding the dates from the argument list of dates that are in the month. The returned list should
contain dates in the order they were originally given. *)

(* date list * int -> date list *)
(* returns the dates from the input date list that are in the input month *)
fun dates_in_month (dl : date list, m : int) =
    if null dl
    then []
    else
        if #2 (hd dl) = m
        then hd dl :: dates_in_month (tl dl, m)
        else dates_in_month (tl dl, m)

(* Working alternative version with pattern matching: *)
(* fun dates_in_month (dl : date list, m : int) =
    case dl of
          [] => []
        | (y1,m1,d1)::dl' => if m1 = m
                             then (y1,m1,d1) :: dates_in_month (dl', m)
                             else dates_in_month (dl', m) *)


(* 5. Write a function dates_in_months that takes a list of dates and a list of months (i.e., an int list)
and returns a list holding the dates from the argument list of dates that are in any of the months in
the list of months. Assume the list of months has no number repeated. Hint: Use your answer to the
previous problem and SML's list-append operator (@). *)

(* date list * int list -> date list *)
(* returns filtered input date list containing dates whose months are
in the input months list *)
fun dates_in_months (dl : date list, ml : int list) =
    if null ml
    then []
    else dates_in_month (dl, hd ml) @ dates_in_months (dl, tl ml)

(* Working version with pattern matching: *)
(* fun dates_in_months (dl : date list, ml : int list) =
    case ml of
          [] => []
        | m::ml' => dates_in_month (dl,m) @ dates_in_months (dl,ml') *)


(* 6. Write a function get_nth that takes a list of strings and an int n and returns the nth element of the
list where the head of the list is 1st. Do not worry about the case where the list has too few elements:
your function may apply hd or tl to the empty list in this case, which is okay. *)

(* string list * int -> string *)
(* returns the nth element of a string list *)
fun get_nth (sl : string list, n : int) =
    if n=1
    then hd sl
    else get_nth (tl sl, n-1)


(* 7. Write a function date_to_string that takes a date and returns a string of the form January 20, 2013
(for example). Use the operator ^ for concatenating strings and the library function Int.toString
for converting an int to a string. For producing the month part, do not use a bunch of conditionals.
Instead, use a list holding 12 strings and your answer to the previous problem. For consistency, put a
comma following the day and use capitalized English month names: January, February, March, April,
May, June, July, August, September, October, November, December. *)

(* date -> string *)
(* takes a date and returns astring of the form <M D, Y> (e.g. January 20, 2013) *)
fun date_to_string (d : date) =
    let
        val month_to_str = ["January",   "February", "March",    "April",
                            "May",       "June",     "July",     "August", 
                            "September", "October",  "November", "December"]
        val (y1,m1,d1) = d
    in
        get_nth (month_to_str, m1) ^ " " ^ Int.toString(d1) ^ ", " ^ Int.toString(y1) 
    end


(* 8. Write a function number_before_reaching_sum that takes an int called sum, which you can assume
is positive, and an int list, which you can assume contains all positive numbers, and returns an int.
You should return an int n such that the first n elements of the list add to less than sum, but the first
n+1 elements of the list add to sum or more. Assume the entire list sums to more than the passed in
value; it is okay for an exception to occur if this is not the case. *)

(* int * int list -> int *)
(* return an int n such that the first n elements of the list add to
less than sum, but the first n+1 elements of the list add to sum or more *)

(* Working alternative version with pattern matching and tail recursion: *)
fun number_before_reaching_sum (sum : int, il0 : int list) =
    let
        fun aux (il : int list, n : int, total : int) =
            case il of
                  [] => n
                | i::il' => if total+i >= sum
                            then n
                            else aux (il', n+1, total+i)
    in
        aux (il0, 0, 0)
    end


(* 9. Write a function what_month that takes a day of year (i.e., an int between 1 and 365) and returns
what month that day is in (1 for January, 2 for February, etc.). Use a list holding 12 integers and your
answer to the previous problem. *)

(* int -> int *)
(* takes a day of year (i.e., an int between 1 and 365) and returns
what month that day is in (1 for January, 2 for February, etc.). *)
fun what_month i : int =
    let
        val days_in_months = [31,28,31,30,31,30,31,31,30,31,30,31]
    in
        1 + number_before_reaching_sum (i, days_in_months)
    end


(* 10. Write a function month_range that takes two days of the year day1 and day2 and returns an int list
[m1,m2,...,mn] where m1 is the month of day1, m2 is the month of day1+1, ..., and mn is the month
of day day2. Note the result will have length day2 - day1 + 1 or length 0 if day1>day2. *)

(* date * date -> int list *)
(* takes 2 ints and returns a list of all the months of the days between the day represented
by the 1st int and the day represented by the 2nd int
(inclusive of the months both dates are situated within) *)
fun month_range (day1 : int, day2 : int) =
    if day1 = day2
    then [what_month day2]
    else what_month day1 :: month_range (day1+1, day2)


(* 11. Write a function oldest that takes a list of dates and evaluates to an (int*int*int) option. It
evaluates to NONE if the list has no dates and SOME d if the date d is the oldest date in the list. *)


(* date list -> date option *)
(* osf means oldest date so far *)
fun oldest (dl0 : date list) =
    if null dl0
    then NONE
    else
        let
            fun aux (dl : date list, osf : date) =
                if null dl
                then osf
                else
                    if osf = (0,0,0) orelse is_older (hd dl, osf)
                    then aux (tl dl, hd dl)
                    else aux (tl dl, osf)
        in
            SOME(aux (dl0, (0,0,0)))
        end


(* 12. Challenge Problem: Write functions number_in_months_challenge and dates_in_months_challenge
that are like your solutions to problems 3 and 5 except having a month in the second argument multiple
times has no more effect than having it once. (Hint: Remove duplicates, then use previous work.) *)

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
    

(* date list * int list -> int *)
(* returns the number of dates in the list of dates
   that are in any of the months in the list of months *)
fun number_in_months_challenge (dl : date list, ml : int list) =
    number_in_months (dl, remove_duplicates ml)


(* date list * int list -> date list *)
(* returns filtered input date list containing dates whose months are
in the input months list *)
fun dates_in_months_challenge (dl : date list, ml : int list) =
    dates_in_months (dl, remove_duplicates ml)


(* 13. Challenge Problem: Write a function reasonable_date that takes a date and determines if it
describes a real date in the common era. A "real date" has a positive year (year 0 did not exist), a
month between 1 and 12, and a day appropriate for the month. Solutions should properly handle leap
years. Leap years are years that are either divisible by 400 or divisible by 4 but not divisible by 100.
(Do not worry about days possibly lost in the conversion to the Gregorian calendar in the Late 1500s.) *)

(* date -> bool *)
(* returns true if the input date is valid *)
fun reasonable_date (d : date) =
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
