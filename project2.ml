let validVarNames = ["a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"];;

let partition (input: string list) (bound : string) : string list list =
  let rec aux acc current = function
    | [] -> if current = [] then acc else current :: acc
    | h :: t -> 
        if h = bound then
          aux (current :: acc) [] t
        else
          aux acc (current @ [h]) t
  in
  List.rev (aux [] [] input)
;;

let buildCNF (input : string list) : (string * string) list list = 
  let clauses = partition input "AND" in
  let process_literal literals =
    let rec aux acc = function
      | [] -> acc
      | "NOT" :: var :: rest -> aux ((var, "NOT") :: acc) rest
      | var :: rest -> aux ((var, "") :: acc) rest
    in
    List.rev (aux [] (List.filter (fun x -> x <> "(" && x <> ")" && x <> "OR") literals))
  in
  List.map process_literal clauses
;;

let getVariables (input : string list) : string list = 
  let is_var s = 
    not (s = "(" || s = ")" || s = "AND" || s = "OR" || 
         s = "NOT" || s = "TRUE" || s = "FALSE")
  in
  let rec remove_duplicates = function
    | [] -> []
    | h :: t -> h :: (remove_duplicates (List.filter ((<>) h) t))
  in
  remove_duplicates (List.filter is_var input)
;;

let rec generateDefaultAssignments (varList : string list) : (string * bool) list = 
  match varList with
  | [] -> []
  | h :: t -> (h, false) :: generateDefaultAssignments t
;;

let rec generateNextAssignments (assignList : (string * bool) list) : (string * bool) list * bool = 
  match assignList with
  | [] -> ([], true)
  | (var, value) :: t ->
      if not value then
        ((var, true) :: t, false)
      else
        let (next_t, carry) = generateNextAssignments t in
        ((var, not carry) :: next_t, carry)
;;

let rec lookupVar (assignList : (string * bool) list) (str : string) : bool = 
  match assignList with
  | [] -> false
  | (var, value) :: t -> if var = str then value else lookupVar t str
;;

let evaluateCNF (t : (string * string) list list) (assignList : (string * bool) list) : bool = 
  let eval_literal (var, neg) =
    let value = lookupVar assignList var in
    if neg = "NOT" then not value else value
  in
  let eval_clause clause =
    List.exists eval_literal clause
  in
  List.for_all eval_clause t
;;

let satisfy (input : string list) : (string * bool) list =
  let vars = getVariables input in
  let cnf = buildCNF input in
  let init_assign = generateDefaultAssignments vars in
  let rec try_assignments curr =
    if evaluateCNF cnf curr then curr
    else
      let (next_assign, overflow) = generateNextAssignments curr in
      if overflow then [("error", true)]
      else try_assignments next_assign
  in
  try_assignments init_assign
;;