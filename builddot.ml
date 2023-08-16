open Printf

(* perform word wrap on a string by replacing some spaces with "\n" *)
let wrap line_width txt =
  let words = Str.split (Str.regexp "[ \n]+") txt in
  let buf = Buffer.create line_width in
  let _ =
    List.fold_left (fun (width, sep) word ->
      let wlen = String.length word in
      let len = width + wlen + 1 in
      if len > line_width then (
        Buffer.add_string buf "\\n";
        Buffer.add_string buf word;
        (wlen, " ")
      ) else (
        Buffer.add_string buf sep;
        Buffer.add_string buf word;
        (len, " ")
      )
    ) (0, "") words
  in
  Buffer.contents buf

let env_var_set v =
  try let _ = Sys.getenv v in true with Not_found -> false

let rec lookup_exn kvs k =
  match kvs with
  | [] -> raise Not_found
  | (k',v) :: kvs -> if k=k' then v else lookup_exn kvs k

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
       
let print_ilo (i, ilo) =
  let ilo_str = wrap 20 (as_yaml_string ilo) in
  printf "\n    <%s>%s" i ilo_str

let print_prereq code prereq =
  let prereq_str = Str.global_replace (Str.regexp "\\.") ":" (as_yaml_string prereq) in
  printf "  %s -> %s;\n" prereq_str code  
       
let print_module m =
  let attribs = as_yaml_ordered_list m in
  let name = as_yaml_string (lookup_exn attribs "name") in
  let code = as_yaml_string (lookup_exn attribs "code") in
  let ilos = lookup_exn attribs "ilos" in
  let prereqs = try lookup_exn attribs "prereqs" with Not_found -> `A [] in
  printf "  %s [label=\"{%s | %s | {" code code name;
  iter_alt print_ilo (fun () -> printf " |") (as_yaml_ordered_list ilos);
  printf "\n  }}\"];\n";
  List.iter (print_prereq code) (as_yaml_dictionary prereqs)

let print_root_edge m =
  let attribs = as_yaml_ordered_list m in
  let code = as_yaml_string (lookup_exn attribs "code") in
  printf "  root -> %s;\n" code
  
let print_root_edges modules =
  printf "  root[label=\"start\"]\n";
  List.iter print_root_edge modules;
  printf "\n"
  
let _ =
  let darkturquoise = "#99d8c9" in
  let lightturquoise = "#e5f5f9" in
  let darkorange = "#fdbb84" in
  let lightorange = "#fee8c8" in
  let darkpurple = "#9ebcda" in
  let lightpurple = "#e0ecf4" in
  let darkpink = "#e7298a" in
  let lightpink = "#f2d8e5" in
  printf "// This is an auto-generated file. Don't edit this file; edit `modules.yml` instead.\n\n";
  printf "digraph {\n";
  printf "  node[shape=\"record\", style=\"filled\"];\n";
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  let all_modules = as_yaml_dictionary yml_top in
  let year_is y m = as_yaml_number (lookup_exn (as_yaml_ordered_list m) "year") = float_of_int y in
  let ee1_modules = List.filter (year_is 1) all_modules in
  let ee2_modules = List.filter (year_is 2) all_modules in
  let ee3_modules = List.filter (year_is 3) all_modules in
  let ee4_modules = List.filter (year_is 4) all_modules in
  printf "\n";
  printf "  node[color=\"%s\", fillcolor=\"%s\"];\n" darkturquoise lightturquoise;
  printf "\n";
  iter_alt print_module (fun () -> printf "\n") ee1_modules;
  printf "\n";
  if env_var_set "INCLUDEROOTNODE" then
    print_root_edges ee1_modules;
  printf "  node[color=\"%s\", fillcolor=\"%s\"];\n" darkorange lightorange;
  printf "\n";
  iter_alt print_module (fun () -> printf "\n") ee2_modules;
  printf "  node[color=\"%s\", fillcolor=\"%s\"];\n" darkpurple lightpurple;
  printf "\n";
  iter_alt print_module (fun () -> printf "\n") ee3_modules;
  printf "  node[color=\"%s\", fillcolor=\"%s\"];\n" darkpink lightpink;
  printf "\n";
  iter_alt print_module (fun () -> printf "\n") ee4_modules;
  printf "}\n";
  ()
