let rec lookup_exn kvs k =
  match kvs with
  | [] -> raise Not_found
  | (k',v) :: kvs -> if k=k' then v else lookup_exn kvs k

let env_var_set v =
  try let _ = Sys.getenv v in true with Not_found -> false

(* `iter_alt f g [x1;x2;x3]` is `f x1; g (); f x2; g (); f x3` *) 
let rec iter_alt f g = function
  | [] -> ()
  | [x] -> f x
  | x :: xs -> f x; g (); iter_alt f g xs

let as_yaml_string ?(msg = "Expected a YAML string") = function
  | `String s -> s
  | _ -> failwith msg

let as_yaml_number ?(msg = "Expected a YAML number") = function
  | `Float f -> f
  | _ -> failwith msg

let as_yaml_ordered_list ?(msg = "Expected a YAML ordered list") = function
  | `O xs -> xs
  | _ -> failwith msg
       
let as_yaml_dictionary ?(msg = "Expected a YAML dictionary") = function
  | `A xs -> xs
  | _ -> failwith msg
