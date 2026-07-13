include Lexer
type tree = Node of (tree * token * tree) | Leaf of int

let parser_suffix (l : token list) : tree =
  let rec aux (l: token list) (stack : tree list) : tree =
    match l with
    |[] -> 
      begin
      match stack with
      |[] -> invalid_arg "The expression might not be empty."
      |[x] -> x
      |_ -> invalid_arg "Incomplete expression."
      end
    |x::q -> 
      begin
      match x, stack with
      |INT a, _ -> aux q (Leaf a :: stack)
      |tok, right::left::s -> aux q (Node(left, tok, right)::s)
      |_-> invalid_arg "Incomplete expression"
      end
  in
  aux l []


let prop = function
  |PLUS  | MINUS  -> 1
  |TIMES | DIVIDE -> 2
  |_              -> 0
let infix_to_suffix (l : token list) : token list =
  let rec aux (l : token list) (stack : token list) (acc : token list) : token list = 
    match l, stack with
    | [], [] -> List.rev acc
    | [], op::s -> aux l s (op :: acc)
    | x::q, stack -> 
      begin
        match x with
        |INT a -> aux q stack (INT a :: acc)
        |LPARENT -> aux q (LPARENT :: stack) acc
        |RPARENT -> 
          let rec pop_to_lpar s a =
            match s with
            |LPARENT :: q -> (q, a)
            |op :: q -> pop_to_lpar q (op :: a)
            |_-> failwith "Parenthesis Error"
          in
          let new_stack, new_acc = pop_to_lpar stack acc in
          aux q new_stack new_acc
        | op    ->
          let rec pop_prio s a =
            match s with
            |top :: q when prop top >= prop op -> pop_prio q (top::a)
            |_ -> (s, a)
          in
          let new_stack, new_acc = pop_prio stack acc in
          aux q (op :: new_stack) new_acc
      end
  in
  aux l [] []

let parser (l : token list) : tree =
  parser_suffix (infix_to_suffix l)