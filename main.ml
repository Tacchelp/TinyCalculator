include Lexer
include Parser


let rec calc (t : tree) : int =
  match t with 
  | Leaf a -> a
  | Node (left, PLUS, right)   -> (calc left) + (calc right)
  | Node (left, MINUS, right)  -> (calc left) - (calc right)
  | Node (left, TIMES, right)  -> (calc left) * (calc right)
  | Node (left, DIVIDE, right) -> (calc left) / (calc right)
  |_ -> invalid_arg "Parenthesis"

let () = 
  let input = read_line () in
  Printf.printf "The result is: %d\n" (calc (parser (lexer input)))