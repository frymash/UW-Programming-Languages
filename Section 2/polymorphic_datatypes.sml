(* Polymorphic datatypes *)
datatype 'a my_list = Empty | Cons of 'a * 'a my_list
datatype 'a option = None | Some of 'a
datatype 'a tree = Leaf of 'a
                 | Node of 'a * 'a tree * 'a tree
datatype ('a, 'b) tree = Leaf of 'b
                       | Node of 'a * ('a, 'b) tree * ('a, 'b) tree


(* Functions for ('a, 'b) tree  *)

(* Sums the values of all leaves in a given tree  *)
(* ('a, int) tree -> int *)
fun sum_leaves t =
    case t of
          Leaf i => i
        | Node (i, lt, rt) => sum_leaves lt + sum_leaves rt


(* Sums the values of nodes and leaves in a given tree *)
(* (int, int) tree -> int *)
fun sum_tree t =
    case t of
          Leaf i => i
        | Node (i, lt, rt) => i + sum_tree lt + sum_tree rt


(* Counts the number of leaves present in a given tree *)
(* ('a, 'b) tree -> int *)
fun num_leaves t =
    case t of
          Leaf i => 1
        | Node (i, lt, rt) => num_leaves lt + num_leaves rt
