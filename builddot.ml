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

let rec lookup_exn kvs k =
  match kvs with
  | [] -> raise Not_found
  | (k',v) :: kvs -> if k=k' then v else lookup_exn kvs k

(* `iter_alt f g [x1;x2;x3]` is `f x1; g (); f x2; g (); f x3` *) 
let rec iter_alt f g = function
  | [] -> ()
  | [x] -> f x
  | x :: xs -> f x; g (); iter_alt f g xs

let as_yaml_string = function
  | `String s -> s
  | _ -> failwith "Expected a string"

let print_ilo (i, ilo) =
  let ilo_str = as_yaml_string ilo in
  let ilo_str = wrap 20 ilo_str in
  printf "\n    <%s>%s" i ilo_str
  
let print_ilos = function
  | `O ilo_list -> iter_alt print_ilo (fun () -> printf " |") ilo_list
  | _ -> failwith "Expected an ordered list of ILOs"

let print_prereq code prereq =
  let prereq_str = as_yaml_string prereq in
  let prereq_str = Str.global_replace (Str.regexp "\\.") ":" prereq_str in
  printf "  %s -> %s;\n" prereq_str code
       
let print_prereqs code = function
  | `A prereq_list -> List.iter (print_prereq code) prereq_list
  | _ -> failwith "Expected an unordered list of prerequisites"
       
let print_module = function
  | `O attribs -> 
     let name = as_yaml_string (lookup_exn attribs "name") in
     let code = as_yaml_string (lookup_exn attribs "code") in
     let ilos = lookup_exn attribs "ilos" in
     let prereqs = try lookup_exn attribs "prereqs" with Not_found -> `A [] in
     printf "  %s [label=\"{%s | %s | {" code code name;
     print_ilos ilos;
     printf "\n  }}\"];\n";
     print_prereqs code prereqs
  | _ -> failwith "Expected a collection of module attributes"

let print_top = function
  | `A module_list -> iter_alt print_module (fun () -> printf "\n") module_list
  | _ -> failwith "Expected a list of modules"

let _ =
  printf "// This is an auto-generated file. Don't edit this file; edit `modules.yml` instead.\n\n";
  printf "digraph {\n";
  printf "  node[shape=record, style=\"filled\"];\n";
  printf "  node[color=\"#99d8c9\", fillcolor=\"#e5f5f9\"];\n";
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  print_top yml_top;
  printf "}\n";
  ()
