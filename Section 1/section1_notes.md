
The actual Notion notes I use can be found [here](https://www.notion.so/ozervesh/Section-1-Basic-SML-Syntax-d50819f1086d4f75a9ac0d81d713be95).
This file is a copy of my notes for section 1 as of Wednesday, 14 September 2022.


# Section 1 (Basic SML Syntax)

---

## ML Variable Bindings and Expressions

```
🗒️ Before a program is run, the types of the variable bindings (**static environment**) are checked to ensure that
every variable binding in the program is typed correctly.

While a program is run, the values of the variable bindings (**dynamic environment**) are evaluated.
```

- Variables in ML are written in the following format:
    
    ```ocaml
    val x = e;
    ```
    
    - Let’s run through the syntax step by step:
        - `val` is a keyword
        - `x` is a variable
        - `=` is the assignment operator
        - `e` is an expression (which evaluates to a value v) of type t
        - the semicolon indicates that the variable binding has ended (optional in files but compulsory in the SML REPL)

- **Static environment** - the **types** of the preceding bindings in a file
    - AKA context of the program so far
    - Responsible for type-checking
    - For the following code snippet:
        
        ```ocaml
        (* keyword variable = expression/value *)
        val x = 51;
        val y = 17;
        ```
        
        - To type check the variable binding `val y = 17;`, we use the “current static environment” to type-check `y` and produce a “new static environment”.
        - This “new static environment” consists of the current static environment except with `y` having type `int` (since `int` is the type of `17`)
        
    
- **Dynamic environment -** the **values** of the preceding bindings in a file
    - Responsible for evaluating expressions
    
- Here’s a short program that shows how the static and dynamic environments change after each variable binding.
    
    ```ocaml
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
    ```
    
    Or in a more abstract sense,
    
    ```ocaml
    val x = e1
    (* Static environment: x: t1 *)
    (* Dynamic environment: x --> v1 *)
    
    val y = e2
    (* Static environment: x: t1, y: t2 *)
    (* Dynamic environment: x --> v1, y --> v2 *)
    ```
    

- **Syntax** → how to write something
- **Semantics** → what something means
    - 1.    Type-checking (Done *before* program runs; if a type in the current static environment is incorrect, an error is thrown.)
        - For example:
            - Ensure all variables are defined with a name
            - Ensure function inputs are of the correct type
            - Ensure that nothing that’s not a number is being added
    - 2.    Evaluation (Done *while* program runs; looks up values in the current dynamic environment)
    
- At variable bindings, we…
    - type-check the expression (right-hand side) and extend the static environment
    - evaluate the expression (right-hand side) and extend the dynamic environment

- Each kind of expression (e.g. conditionals, functions, variables) has its own type-checking and evaluation rules.

---

## Rules of Expressions

At this point, we have seen many different kinds of expressions. For example:

- `34`
- `true`
- `false`

- `x`
- `e1 + e2`

- `e1 < e2`
- `if e1 then e2 else e3`

- What are values? Which expressions in the list above are values?
    - All values are expressions, but not all expressions are values
    - Every value “evaluates to itself” “within 0 steps” in the dynamic environment.
    - Values can’t be broken down/evaluated further.
    - e.g. `34`, `true`, `false`, `x`
    - not values: `e1 + e2`, `e1 < e2`, `if e1 then e2 else e3`

- Expressions can get arbitrarily large as subexpressions can contain subexpressions.

- When encountering any expression, there are 3 essential questions you should try to answer:
    1. What is its **syntax**?(how the expression is written)
    2. What are its **type-checking rules**? (which types are allowed in expressions)
    3. What are its **evaluation rules**? (how the expression is run in the program)

- Syntax + semantics for some expressions
    - Integer constants (values)
        - **Syntax:** a sequence of digits
        - **Type-checking:** type `int` in any static environment
        - **Evaluation:** to itself in any dynamic environment (it is a value)
    - Variables (values)
        - **Syntax:** a sequence of letters, underscores, etc. (but doesn’t begin with numbers)
        - **Type-checking:** look up the variable in the current static environment and use that type
        - **Evaluation:** look up the variable in the current dynamic environment and use that value
    - Addition
        - **Syntax:** `e1+e2` where `e1` and `e2` are expressions
        - **Type-checking:** type `int` but only if `e1` and `e2` have type `int` in the same static environment, else does not type-check
        - **Evaluation:** evaluate `e1` to `v1` and `e2` to `v2` in the same dynamic environment and then produce the sum of `v1` and `v2`
    - Conditionals
        - **Syntax:** `if e1 then e2 else e3`
            - where `if`, `then`, and `else` are keywords and
            - `e1`, `e2`, and `e3` are expressions
        - **Type-checking:** using the current static environment, a conditional type-checks only if (a) `e1` has type `bool` and (b) `e2` and `e3` have the same type. The type of the whole expression is the type of `e2` and `e3`.
        - **Evaluation:** under the current dynamic environment, evaluate `e1`. If the result is `true`, the result of evaluating `e2` under the current dynamic environment is the overall result. If the result is `false`, the result of evaluating `e3` under the current dynamic environment is the overall result.
    - Boolean constants
        - **Syntax:** either `true` or `false`
        - **Type-checking:** type `bool` in any static environment
        - **Evaluation:** to itself in any dynamic environment (it is a value)
    - Less-than comparison
        - **Syntax:** `e1 < e2` where `e1` and `e2` are expressions
        - **Type-checking:** type `bool` but only if `e1` and `e2` have type `int` in the same static environment, else does not type-check
        - **Evaluation:** evaluate `e1` to `v1` and `e2` to `v2` in the same dynamic environment and then produce `true` if `v1` is less than `v2` and false otherwise

---

## The REPL and Errors

- The **read-eval-print-loop (REPL)** is an environment that **reads** an expression, **evaluates** it, and **prints** the result before accepting another expression as input. The process repeats (**loops**) until the environment is closed.
    - The REPL is typically used for debugging.
    - You can also use the REPL to test certain ideas out.

- The `use` keyword can be used to import variable bindings from a .sml file into the SML REPL.
    - Here’s some sample code in a file named `foo.sml`
        
        ```ocaml
        val x = 1;
        val y = 2;
        val z = 50;
        val abs_of_z = if z < 0 then ~z else z
        ```
        
    - Now, we’ll use the `use` keyword to import bindings from `foo.sml` into the REPL.
        
        ```ocaml
        - use "foo.sml";
        [opening foo.sml]
        val x = 1 : int
        val y = 2 : int
        val z = 50 : int
        val abs_of_z = 50 : int
        ```
        

- Errors
    - Errors occur when something’s wrong with an expression.
    - Given that we know each expression has its own syntax and semantics (type-checking rules and evaluation rules), this means that errors occur if there’s a mistake in an expression’s syntax, types, or evaluation.
        - **Syntax**: What you wrote either means nothing or doesn’t mean what you intended
        - **Type-checking rules**: What you wrote doesn’t type-check i.e. the types in your expression are incorrect
        - **Evaluation**: What you wrote runs normally but produces the wrong answer, runs into an exception somewhere, or gets trapped in an infinite loop
    - Sometimes, the errors are caught and program execution is suspended (e.g. syntax error gets caught in the static environment).
    - However, there are also times where issues with the program aren’t caught by the compiler/interpreter (e.g. infinite loops).

---

## Shadowing

```
⬅️ Technically speaking, Standard ML doesn’t have assignment statements. Any mapping of a variable name to an expression is known as a **variable binding**. Take note of this while reading through this section.

```

- **Shadowing** occurs when a there are multiple bindings for the same variable.
- For example, let’s say a variable `val a = 1` is declared at the start of a program. Somewhere later in the program, this same variable is redeclared as `val a = 2`.
- In the static + dynamic environments for the line `val a = 2`, we can say that `a` has been shadowed in these environments. The new value of `a` sort of ‘supersedes’ the previous values mapped to `a` in previous environments.

- Here’s an example with more detail.
    - In the following code snippet `shadowing.sml`, `a` is declared before being shadowed twice. Every time a new binding for `a` is written, `a`'s new value replaces `a`'s previous value in the dynamic environment.
        
        ```ocaml
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
        ```
        
        ```
        🎭 It’s worth noting that SML is an **eagerly-evaluated language**. That means that variable bindings are evaluated before they “finish”.
        
        For example, let’s consider the variable binding  `val c = c + b` from the snippet above.
        
        In **eager evaluation**, we would evaluate the result of `c + b` and map that value to `c`. Given that `b --> 2` and `c --> 100` in the previous dynamic environment, `c + b` evaluates to `100 + 2`, which evaluates to `102` in turn. Hence, `c` is eventually mapped to `102` in the current dynamic environment.
        
        In **lazy evaluation**, however, `c` would be mapped to the expression `c + b` in the current dynamic environment. The evaluation of `c + b` will be delayed until the program requires it, if ever (hence the “laziness”).
        
        Examples of eagerly-evaluated languages: Java, JavaScript, Python
        Examples of lazily-evaluated languages: Haskell, Miranda
        
        ```
        
    - Perhaps the “shadowing” phenomenon is clearer if we import `shadowing.sml` into the REPL. Notice this: each bindings of `a` is recorded, but any former bindings for `a` become `<hidden>` from view.
        
        ```ocaml
        - use "shadowing.sml";
        [opening shadowing.sml]
        val a = <hidden> : int
        val b = 2 : int
        val a = <hidden> : int
        val c = <hidden> : int
        val c = 102 : int
        val a = 15 : int
        val it = () : unit
        ```
        

- Note that you shouldn’t use `use` more than once in a REPL as subsequent imports of variable bindings could shadow previous bindings for variables of the same name. This could either
    - make correct code look wrong or
    - make wrong code look correct

---

## Functions Informally

- In SML, functions are written in the format `fun name(x: t1, y: t2) = e`, where
    - `fun` is the keyword for a function
    - `name` is the function name
    - `x` and `y` are function parameters
    - `t1` is the type for `x` and `t2` is the type for `y`
    - `e` is an expression
    
- For example, a function for finding the result of $x^y$can be implemented using the following function binding (`pow.sml`):
    
    ```ocaml
    fun pow(x: int, y: int) =
    (* returns the value of x^y *)
    (* only works if y >= 0, otherwise it'll run infinitely *)
    	if y = 0
    	then 1
    	else x * pow(x, y-1)
    ```
    

- In static environments, the types of the function parameters and the return value of the function will be checked.
    - For instance, importing `pow.sml` into the REPL would produce the following output:
        
        ```ocaml
        - use "pow.sml";
        [opening pow.sml]
        val pow = fn : int * int -> int
        val it = () : unit
        ```
        
        ```
        ⭐ The types of function arguments are typically separated by a “*”.
        The ”*” does NOT indicate multiplication in function signatures.
        
        ”->” indicates the transformation of function input into output.
        
        ```
        
    
    - `val pow = fn : int * int -> int` shows the REPL’s understanding that `pow` takes 2 integers as input and returns an integer value as output.
    
- Note that ML doesn’t allow you to call functions before they are defined.

---

## Functions Formally

- With functions, we must still remember to ask the 3 questions we ponder when we encounter any expression. A function is an expression as well.

- What is a function’s….
    - **Syntax**: `fun f0(e1: t1, e2: t2, ... en: tn) = e`
    - **Type-checking rules**:
        - Adds binding `f0 : (t1 * t2 * ... * tn) -> t` if function body `e` can be type-checked to have type `t` in the static environment containing
            - The “enclosing” static environment (i.e. previous bindings)
            - The function’s arguments and their types (i.e. `f1 : e1: e1, e2: t2, ... en: tn`). Note that these types don’t exist in the static environment outside the scope of the function; they’re only in the static environment for the function body `e`.
            - Types in the arguments for recursive calls of the function
                
                (i.e. `f0 : (t1 * t2 * ... * tn) -> t`)
                
    - **Evaluation rules**:
        - A function is a value that can be stored and reused in later parts of the program.
        - When we define a function, no evaluation is being done yet.
        - Evaluation only takes place when a function is called.

- To use a function, **we need to call it only after it is defined**.
- What is a function call’s…
    - **Syntax**: `e0(e1, ... , en)`, where `f0` is the function and `e1, ... , en` are the function arguments. In SML, wrapping arguments with parentheses is optional if the function only accepts 1 argument.
    - **Type-checking rules**:
        - If  `e0` has type `(t1 * ... * tn) -> t`
            
            and `e1, ... , en` have types `t1, ... , tn`,
            
            then `e0(e1, ... , en)` has type `t`.
            
        - e.g. `pow(x, y-1)` has type `(int * int) -> int`. Since `x, y-1` have types `int, int`, we can infer that the type for `pow(x, y-1)` is `int`.
    - **Evaluation rules**:
        1. Evaluate `e0` to `fun f0(e1: t1, e2: t2, ... en: tn) = e` (under current dynamic environment)
        2. Evaluate function arguments `e1, e2, ... en` to `v1, v2, ... vn`.
        3. Return value arises from the evaluation of `e` in a dynamic environment where `e1, e2, ... en` maps to `v1, v2, ... vn`. (This particular dynamic environment extends to the environment where the function was initially defined. It also includes recursive calls of `f0`.)

---

## Pairs and Other Tuples

- **Tuples** are a type of compound data that have a fixed length.
- Each element of a tuple can have a different type.

- **Pairs (2-tuples)** are tuples of size 2. When building and accessing pairs, different syntax, type-checking rules and evaluation rules have to be followed.
    - Building
        - **Syntax**: `(e1, e2)` where `e1`,`e2` are expressions
        - **Type-checking rules**: If `e1` has type `t1` and `e2` has type `t2`, then the pair has type `t1 * t2`.
        - **Evaluation rules**: `e1` evaluates to `v1` and `e2` evaluates to `v2`, hence `(e1, e2)` evaluates to `(v1,v2)`.
    - Accessing (where `e` is a pair)
        - **Syntax**: `#1 e` to access the 1st value and `#2 e` to access the 2nd value.
        - **Type-checking rules**: If the pair has type `t1 * t2`, then `#1 e` has type `t1` and `#2 e` has type `t2`.
        - **Evaluation rules**: Evaluate `e` to a value `v` then return the 1st or 2nd piece.
            - e.g. If `e` is a variable `x`, then look `x` up in the current dynamic environment.

```
🏸 For pairs, it might be useful liken `#1 e` and `#2 e` to `(first e)` and `(rest e)` in DrRacket’s Student Languages.

```

- We can generalise these rules for tuples of size n.
    - Building
        - **Syntax**: `(e1, e2, ..., en)` where `e1, e2, ..., en` are expressions
        - **Type-checking rules**: If `e1` has type `t1` , `e2` has type `t2`, …, and `en` has type `tn`, then the tuple has type `t1 * t2 * ... * tn`.
        - **Evaluation rules**: `e1` evaluates to `v1`, `e2` evaluates to `v2`, …, and `en` evaluates to `tn`, hence `(e1, e2)` evaluates to `(v1,v2, ...,vn)`.
    - Accessing (where `e` is a tuple)
        - **Syntax**: `#1 e` to access the 1st value, `#2 e` to access the 2nd value, …, and `#n e` to access the nth value.
        - **Type-checking rules**: If the pair has type `t1 * t2 * ... * tn`, then `#1 e` has type `t1` , `#2 e` has type `t2`, …, and `#n e` has type `tn`.
        - **Evaluation rules**: Evaluate `e` to a value `v` then return one of its piece.
            - e.g. If `e` is a variable `x`, then look `x` up in the current dynamic environment.

- Tuples can be nested e.g. `val t = (1, (2, true))`

---

## Introducing Lists

- Lists are compound data which don’t really “commit” to having a particular “amount” of data i.e. they are arbitrarily-sized.
- Unlike tuples, lists don’t have a fixed length and all of its elements need to have the same type.

- **Syntax**:
    - In general, a list of expressions is a value consisting of elements separated by commas: `[e1, e2, e3, ..., en]`.
    - The empty list is a value `[]`.
    - If an expression `e1` evaluates to `v1` and an expression `e2` evaluates to `[v2, v3, v4, ..., vn]`, then `e1::e2` evaluates to `[v1, v2, v3, v4, ..., vn]`. `::` is essentially the equivalent of `cons` from Lisp-based languages.
- **Type-checking rules**: For any type `t` , the type `t list` describes a list where all elements have type `t`.
- **Evaluation rules:** If `e1` evaluates to `v1` and `en` evaluates to `vn`, `[e1, e2, e3, ..., en]` evaluates to `[v1, v2, v3, ..., vn]`.

| SML List Function | Racket equivalent | Signature (SML) | Signature (Racket) |
| --- | --- | --- | --- |
| null e | (empty? e) | ‘a list → bool | (listof X) → Bool |
| hd e | (first e) | ‘a list → ‘a | (listof X) → X |
| tl e | (rest e) | ‘a list → ‘a list | (listof X) → (listof X) |
| e1 :: e2 | (cons e1 e2) | 'a * ‘a list → ‘a list | X (listof X) → (listof X) |

---

## List Functions

```ocaml
(* int list ->  int *)
(* returns the sum of all elements in an int list *)
fun sum_list(xs : int list) =
  if null xs
  then 0
  else (hd xs) + sum_list(tl xs)

(* int -> int list *)
(* creates an int list that counts down from the input number to 0 *)
fun countdown(x : int) =
  if x = 0
  then []
  else x :: countdown(x - 1)

(* ('a list) * ('a list) -> 'a list *)
(* appends the 2nd input list onto the 1st input list *)
fun append(xs : 'a list, ys : 'a list) =
  if null xs
  then ys
  else (hd xs) :: append((tl xs), ys)

(* (int * int) list -> int *)
(* sums all elements in an (int * int) list *)
fun sum_pair_list(xs : (int * int) list) =
  if null xs
  then 0
  else #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs)

(* (int * int) list -> int list *)
(* returns a list of the 1st elements from every pair in a list of (int * int) pairs *)
fun firsts(xs : (int * int) list) = 
  if null xs
  then []
  else #1 (hd xs) :: firsts(tl xs)

(* (int * int) list -> int list *)
(* returns a list of the 2nd elements from every pair in a list of (int * int) pairs *)
fun seconds(xs : (int * int) list) = 
  if null xs
  then []
  else #2 (hd xs) :: seconds(tl xs)

(* (int * int) list -> int *)
(* sums all elements in an (int * int) list *)
fun sum_pair_list2(xs : (int * int) list) =
  (sum_list(firsts(xs))) + (sum_list(seconds(xs)))
```

- List template (adapted from UBC’s “How to Code”)
    
    ```ocaml
    fun fn-for-list(xs : 'a list) =
    	if null xs
    	then (...)
    	else (hd xs) ... fn-for-list((tl xs))
    ```
    

- Functions on lists are typically recursive as that’s the only way you can get to “the rest of the elements” in the list.
    - Functions that produce lists of any size should also be recursive.

- A few things to think about with regards to list functions
    - What should the result be if the list is empty?
    - What should the result be if the list is **not** empty?

---

## Let Expressions

- `let` expressions are used to define local variables for a function.

- **Syntax**: `let b1, b2, ..., bn in e end`, where each `bi` is a binding and `e` is any expression.
- **Type-checking rules**: Type-check each `bi` and `e` in a static environment that includes the earlier bindings in the program.
- **Evaluation rules**:
    - Evaluate each `bi` and `e` in a dynamic environment that includes the earlier bindings in the program.
    - The result of the whole `let` function is the value that arises from `e`'s evaluation.
    
- In `let` expressions, the bindings `b1, b2, ..., bn` declared between `let` and `in` are only in scope within the body of the `let` expression.
    - These bindings cannot be accessed outside the scope of the `let` expression.
    - These bindings mustn’t necessarily be variable bindings — they can be function bindings (helper functions) or any other kind of binding as well.

---

## Nested Functions

- Let’s have a look at 2 related functions `count` and `count_from_1`.
    - `count_from_1` uses `count` in its body
    
    ```ocaml
    (* int * int -> int list *)
    (* returns a list consisting every number from first to last *)
    fun count (first : int, last : int) =
        if first = last
        then last :: []
        else first :: count(first + 1, last)
    
    (* int -> int list *)
    (* returns a list counting from 1 to x *)
    fun count_from_1 (x : int) = 
        count (1, x)
    ```
    

- Given that `count` is a function that will only be used by `count_from_1`, it would be good practice for us to nest `count` within `count_from_1` as a local function.
    - Ideally, we’d like to hide the implementation of `count` from the rest of the program since the rest of the program doesn’t need it.
    
    ```ocaml
    fun count_from_1 (x : int) = 
        let
            fun count (first : int, last : int) =
                if first = last
                then last :: []
                else first :: count(first + 1, last)
        in
            count (1, x)
        end
    ```
    

- Alternatively, we can rewrite this function such that `last` is removed from `count`'s parameters. This would be possible (and considered as good style) since
    - `count` can access `x` since `x` is from an outer environment (functions can access bindings from a. the environment they were defined within and b. enclosing/outer environments)
    - Unnecessary parameters (like `last` in the previous example) would be considered bad style.
    
    ```ocaml
    fun count_from_1 (x : int) = 
        let
            fun count (first : int) =
                if first = x
                then x :: []
                else first :: count(first + 1)
        in
            count (1)
        end
    ```
    

- When do we use nested/local/helper functions?
    - If a function is only helpful to 1 function and is
        1. Unlikely to be useful elsewhere in the program,
        2. Likely to be misused if accessible elsewhere in the program,
        3. Likely to be modified or removed later,
        
        … it’ll be good style to encapsulate the helper function within the main function.
        
- A fundamental trade-off in code design is as follows:
    - Reusing code (as is done with nested/local/helper functions) saves effort and reduces bugs, but reused code will be harder to change later when it’s used multiple times in different areas of code.
    - As such, the use of nested/local/helper functions may not always be best choice when programming.
    - When using nested/local/helper functions, do take note of these trade-offs.

---

## Let and Efficiency

- When using a recursive expression more than once, it’s better to store it as a variable to avoid unnecessary recomputation

- For example, let’s look at a function `bad_max` (a bad implementation of a function that finds the maximum element in a list of integers)
    
    ```ocaml
    fun bad_max (xs : int list) =
    	if null xs
    	then 0 (* horrible style, but we'll fix it in the next section *)
    	else if null (tl xs)
    	then hd xs
    	else if hd xs > bad_max (tl xs)
    	then hd xs
    	else bad_max (tl xs)
    ```
    
    - Given that `bad_max (tl xs)` is called twice, it has to compute the same result twice.
    - This is terrible as the number of recursive calls will grow exponentially (making `bad_max` run in $O(2^n)$ time in the worst case).
        
        ![Screenshot 2022-08-02 at 8.43.41 PM.png](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-02_at_8.43.41_PM.png)
        

- Including the `let` function will allow the result of `bad_max (tl xs)` to be stored and thereby prevent the need for recomputation.
    - The following function `good_max` is a more efficient version of `bad_max` that includes a `let` function for this reason.
    
    ```ocaml
    fun good_max (xs : int list) =
    	if null xs
    	then 0 (* horrible style, but we'll fix it in the next section *)
    	else if null (tl xs)
    	then hd xs
    	else 
    		let val tl_max = good_max (tl xs)
    		in
    			if hd xs > tl_max
    			then hd xs
    			else tl_max
    		end
    ```
    
    - Given that the recomputation has been avoided, `good_max` would run in linear time ( $O(n)$ ).
        
        ![Screenshot 2022-08-02 at 9.59.49 PM.png](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-02_at_9.59.49_PM.png)
        

---

## Options

- In the example from the previous section, the max function returns `0` if the list is empty. As stated in the code comment, this is horrible style.
    - Doing so could raise an exception.
    - We could also return a 0-element or a 1-element list, but that’d be poor style because we have a direct way to express such a construct in SML — **options**.

- `t option` is a type for any type `t`.

- Building options
    - `NONE` has type `'a option` (just like how `[]` has type `'a list`).
    - `SOME e` has type `t option`  if `e` has type `t` (just like `e::[]`)
- Accessing options
    - `isSome` function
        - Returns true if the option is `SOME e`.
        - Function type (signature): `'a option -> bool`
    - `valOf`  function
        - Returns the value of an option
        - Function type (signature): `'a option -> 'a`

- Let’s use an option to implement a better version of `good_max` — `max1`.
    
    ```ocaml
    fun max1 (xs : int list) =
    	if null xs
    	then NONE
    	else
    		let val tl_max = max1 (tl xs)
    		in if isSome tl_max andalso valOf tl_max > hd xs
    			 then tl_max
    			 else SOME (hd xs)
    		end
    ```
    

- `max1` has 1 issue though — we have to check if `tl_max` is `SOME int` after every recursive call (due to the expression `if isSome tl_max andalso valOf tl_max > hd xs`)
    - To remedy this, we can rewrite the function such that we calculate the maximum of the nonempty list tail before encapsulating the answer in an option.
        
        ```ocaml
        fun max2 (xs : int list) =
        	if null xs
        	then NONE
        	else
        		let
        				fun max_nonempty (xs : int list) =
        					if null (tl xs) (* xs cannot be an empty list here *)
        					then hd xs
        					else
        						let val tl_max = max_nonempty(tl xs)
        						in
        							if hd xs > tl_max
        							then hd xs
        							else tl_max
        						end
        		in
        				SOME (max_nonempty (xs))
        		end
        ```
        

---

## Booleans and Comparison Operations

| Logic gate | ML Operation |
| --- | --- |
| AND | andalso |
| OR | orelse |
| NOT | not |

- For `andalso`:
    - **Syntax**: `e1 andalso e2`
    - **Type-checking rules**: Both `e1` and `e2` must be of type `bool`
    - **Evaluation rules**: If `e1` is `false`, return `false`. Else, return `e2`.

- For `orelse`:
    - **Syntax**: `e1 orelse e2`
    - **Type-checking rules**: Both `e1` and `e2` must be of type `bool`
    - **Evaluation rules**: If `e1` is `true`, return `true`. Else, return `e2`.
    
- For `not`:
    - **Syntax**: `not e1`
    - **Type-checking rules**: `e1` has type `bool`
    - **Evaluation rules**: If `e1` is `true`, return `false`. Else, return `true`.

![Screenshot 2022-08-03 at 10.29.56 PM.png](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-03_at_10.29.56_PM.png)

- Comparisons for `int`s
    
    
    | Comparator | Symbol |
    | --- | --- |
    | Equals | = |
    | Not equals | <> |
    | Less than | < |
    | More than | > |
    | Less than or equal to | <= |
    | More than or equal to | >= |
- Take note of the following rules regarding comparators in ML:
    - `>`, `<`, `>=`, and `<=` cannot be used to compare 1 `int` against 1 `real` (floating point number — like the `float` type in Python). However, they can be used to compare 2 `int`s or 2 `real`s against each other.
    - `=` and `<>` can be used with “equality types” such as `int`. However, they cannot be used on `real` numbers (floating point numbers) as they are subject to rounding errors (e.g. 4.000000001).
        - It’s rarely good practice to check whether 2 floating point numbers are equal to one another due to these rounding errors. ML doesn’t allow for such a comparison to be made anyway.
    

---

## Benefits of No Mutation

- In ML, all data is immutable and cannot be altered after it is declared.
- In languages with mutable data, the programmer must pay careful attention to using aliases and copies of mutable data in the correct situations.
- For languages with immutable data like ML, it’s not possible to distinguish between aliases of data or copies of data. However, that’s not an issue as we’ll never need to worry about accidental changes to mutable data.
    - As such, we can use aliasing in such languages without danger
    
- The danger of mutable data
    
    ![In languages with mutable data, the 1st version of `sort_pair` would return the input pair `pr`. The input `pr` and the output `pr` reference the same data in memory. The 2nd version, however, creates a copy of `pr`. In languages with immutable data (like ML), however, both functions are identical.](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-03_at_11.03.03_PM.png)
    
    In languages with mutable data, the 1st version of `sort_pair` would return the input pair `pr`. The input `pr` and the output `pr` reference the same data in memory. The 2nd version, however, creates a copy of `pr`. In languages with immutable data (like ML), however, both functions are identical.
    
    ![Mutation can be dangerous as we might modify the wrong piece of data by accident.](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-03_at_11.02.27_PM.png)
    
    Mutation can be dangerous as we might modify the wrong piece of data by accident.
    
    ![In languages with mutable data, `val z = append(x,y)` would reference the actual variable `val y` as `append` took `y` as input and returned `y` in its `then` clause. The upper linked list diagram illustrates this. In languages with immutable data, however, the latter diagram will be true since `val y` cannot be modified after it is declared (i.e. `val y` will permanently be `[5,3,0]` unless it’s shadowed).](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-03_at_11.08.45_PM.png)
    
    In languages with mutable data, `val z = append(x,y)` would reference the actual variable `val y` as `append` took `y` as input and returned `y` in its `then` clause. The upper linked list diagram illustrates this. In languages with immutable data, however, the latter diagram will be true since `val y` cannot be modified after it is declared (i.e. `val y` will permanently be `[5,3,0]` unless it’s shadowed).
    
    ![Screenshot 2022-08-03 at 11.15.17 PM.png](Section%201%20(Basic%20SML%20Syntax)%20d50819f1086d4f75a9ac0d81d713be95/Screenshot_2022-08-03_at_11.15.17_PM.png)
