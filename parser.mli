type tree = Node of (tree * Lexer.token * tree) | Leaf of int
val parser_suffix : Lexer.token list -> tree
val prop : Lexer.token -> int
val infix_to_suffix : Lexer.token list -> Lexer.token list
val parser : Lexer.token list -> tree
