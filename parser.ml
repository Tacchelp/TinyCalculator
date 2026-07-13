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