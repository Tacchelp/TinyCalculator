type token =
  Lexer.token =
    PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | INT of int
  | LPARENT
  | RPARENT
val char_to_token : char -> token option
val get_int : char list -> char list * char list
val pre_lexer : char list -> token option list
val lexer : string -> token list
type tree = Node of (tree * token * tree) | Leaf of int
val parser_suffix : token list -> tree
