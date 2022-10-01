(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw1.sml";

val test1 = is_older ((1,2,3),(2,3,4)) = true
val test1b = is_older ((2011,3,31),(2011,4,28)) = true
val test1c = is_older ((2011,4,28),(2011,3,31)) = false

val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1

val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test3b = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2]) = 1

val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"

val test7 = date_to_string (2013, 6, 1) = "June 1, 2013" 

val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3 
val test8b = number_before_reaching_sum (11, [1,2,3,4,5]) = 4
val test8c = number_before_reaching_sum (5, []) = 0   

val test9 = what_month 70 = 3

val test10a = month_range (31, 34) = [1,2,2,2]
val test10b = month_range (1,3) = [1,1,1]
val test10c = month_range (30,33) = [1,1,2,2]
val test10d = month_range (5,3) = []

val test11a = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test11b = oldest([(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test11c = oldest([(2011,3,31)]) = SOME (2011,3,31)
val test11d = oldest([]) = NONE 
val test11e = oldest([(2011,4,28), (2011,4,27)]) = SOME (2011,4,27)
val test11f = oldest([(2012,2,28),(2011,3,27),(2011,4,28)]) = SOME (2011,3,27)


val test12a = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,3,4]) = 3
val test12b = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,3,4]) 
            = [(2012,2,28),(2011,3,31),(2011,4,28)]

val test13a = reasonable_date((2021,3,4)) = true
val test13b = reasonable_date((~1,3,4)) = false
val test13c = reasonable_date((2020,2,29)) = true
val test13d = reasonable_date((1900,2,29)) = false

val test_removeduplicates1 = remove_duplicates([1,1,2,2,3,3,4,4]) = [1,2,3,4]
val test_removeduplicates2 = remove_duplicates([1,2,3,4]) = [1,2,3,4]  
val test_removeduplicates3 = remove_duplicates([1,1,2,3,4]) = [1,2,3,4]
