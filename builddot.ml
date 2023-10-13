open Printf
open Jcommon

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

let print_prereq code prereq =
  let prereq_str = Str.global_replace (Str.regexp "\\.") ":" (as_yaml_string prereq) in
  printf "  %s -> %s;\n" prereq_str code  
       
let print_module m =
  let attribs = as_yaml_ordered_list m in
  let name = as_yaml_string (lookup_exn attribs "name") in
  let code = as_yaml_string (lookup_exn attribs "code") in
  let prereqs = try lookup_exn attribs "prereqs" with Not_found -> `A [] in
  printf "  %s [label=\"{%s | %s}\"];\n" code code name;
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
