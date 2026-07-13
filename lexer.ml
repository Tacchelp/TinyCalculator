type token = PLUS | MINUS | TIMES | DIVIDE | INT of int | LPARENT | RPARENT

let char_to_token (ch : char) : token option =
  match ch with
  |'+' -> Some PLUS
  |'-' -> Some MINUS
  |'*' -> Some TIMES
  |'/' -> Some DIVIDE
  |'(' -> Some LPARENT
  |')' -> Some RPARENT
  |' ' -> None
  | _  -> None

let rec get_int c =
  match c with
  | [] -> ([], [])
  | ( '0'..'9' as x ) :: q -> 
      let (chiffres_suivants, reste) = get_int q in
      (x :: chiffres_suivants, reste)
  | _ -> ([], c)

let rec pre_lexer (c : char list) : token option list =
  match c with
  |[] -> []
  |x::q -> 
    if x >= '0' && x <= '9' then 
      let (i, l) = get_int c  in
      (Some (INT (int_of_string (String.of_seq (List.to_seq i))))) :: (pre_lexer l)
    else (char_to_token x)::(pre_lexer q)

let lexer (c : string) = 
  let tl = pre_lexer (List.of_seq (String.to_seq c)) in
  List.filter_map (fun x -> x) tl