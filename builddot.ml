(* 
Sample usage:

  dune exec -- ./builddot.exe > modules.dot
  dot -Goverlap=false -Tpdf modules.dot -o modules.pdf

or just run `make`.
*)

open Printf
open Jcommon

let dark = function
  | 1 -> "#945050"
  | 2 -> "#985d7d"
  | 3 -> "#7e68a4"
  | 4 -> "#4d5395"
  | _ -> failwith "Bad colour index"
       
let light = function
  | 1 -> "#ffaaaa"
  | 2 -> "#dea8c6"
  | 3 -> "#bba5e3"
  | 4 -> "#9aa3ff"
  | _ -> failwith "Bad colour index"
       
let darkgrey = "#666666"
let lightgrey = "#dddddd"

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

let year_of_code code = int_of_char (code.[4]) - (int_of_char '0') - 3
  
let print_prereq y code prereq =
  let prereq_y = year_of_code prereq in
  if prereq_y < y - 1 then
    printf "  %s -> %s [weight=0];\n" prereq code
  else
    printf "  %s -> %s;\n" prereq code

let dummy_code = function
  | 0 -> "root"
  | 1 -> "ELEC40002"
  | 2 -> "ELEC50001"
  | 3 -> "ELEC60002"
  | 4 -> "ELEC70001"
  | _ -> failwith "Invalid year"

let field_of_module m f =
  lookup_exn (as_yaml_ordered_list m) f

let string_field_of_module m f =
  as_yaml_string (field_of_module m f)

let string_list_field_of_module m f =
  let xs = 
    try as_yaml_dictionary (field_of_module m f)
    with Not_found -> []
  in List.map as_yaml_string xs

let name_of_module m =
  string_field_of_module m "name"

let code_of_module m =
  string_field_of_module m "code"

let major_themes_of_module m =
  string_list_field_of_module m "major themes"

let minor_themes_of_module m =
  string_list_field_of_module m "minor themes"

let prereqs_of_module m =
  string_list_field_of_module m "prereqs"
       
let print_module y m =
  let name = name_of_module m in
  let code = code_of_module m in
  let prereqs = prereqs_of_module m in
  printf "  %s [label=\"{%s | %s}\"];\n" code code (wrap 20 name);
  List.iter (print_prereq y code) prereqs;
  if y > 1 then
    if not (List.exists (fun p -> year_of_code p = y - 1) prereqs) then
      printf "  %s -> %s [style=invis];\n" (dummy_code (y - 1)) code;
  printf "\n"

let print_root_edge m =
  printf "  root -> %s;\n" (code_of_module m)
  
let print_root_edges modules target_theme =
  let lbl = match target_theme with
    | None -> "start"
    | Some t -> sprintf "%s theme" t
  in 
  printf "  root[label=\"%s\", color=\"%s\", fillcolor=\"%s\"];\n" lbl darkgrey lightgrey;
  List.iter print_root_edge modules;
  printf "\n"
  
let module_from_code all_modules mc =
  match List.filter (fun m -> code_of_module m = mc) all_modules with
  | [m] -> m
  | [] -> failwith (sprintf "Couldn't find module with code %s" mc)
  | _ -> failwith (sprintf "Found multiple modules with code %s" mc)

let prereqs_by_code all_modules mc =
  prereqs_of_module (module_from_code all_modules mc)
       
let add_prereq_codes all_modules ms =
  let f ms = List.concat (List.map (prereqs_by_code all_modules) ms) in
  remdups (ms
           @ iter_fun f 1 ms
           @ iter_fun f 2 ms
           @ iter_fun f 3 ms
           @ iter_fun f 4 ms
           @ iter_fun f 5 ms
           @ iter_fun f 6 ms
           @ iter_fun f 7 ms
           @ iter_fun f 8 ms
           @ iter_fun f 9 ms)


let mem_opt xo xs = match xo with
  | None -> true
  | Some x -> List.mem x xs
   
let contains_major_theme (target_theme : string option) m =
  mem_opt target_theme (major_themes_of_module m)
                 
let contains_minor_theme (target_theme : string option) m =
  mem_opt target_theme (minor_themes_of_module m)
    
let contains_theme (target_theme : string option) m =
  mem_opt target_theme (major_themes_of_module m @ minor_themes_of_module m)
  
let main (target_theme : string option) = 
  printf "// This is an auto-generated file. Don't edit this file; edit `modules.yml` instead.\n\n";
  printf "digraph G {\n";
  printf "  graph[root=\"root\"];\n";
  printf "  node[shape=\"record\", style=\"filled\"];\n";
  printf "\n";
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  let all_modules = as_yaml_dictionary yml_top in
  let theme_module_codes =
    List.map code_of_module (List.filter (contains_theme target_theme) all_modules)
  in
  let all_module_codes = add_prereq_codes all_modules theme_module_codes in
  let all_modules = List.map (module_from_code all_modules) all_module_codes in
  let year_is y m = as_yaml_number (lookup_exn (as_yaml_ordered_list m) "year") = float_of_int y in
  let modules_by_year y = List.filter (year_is y) all_modules in
  for y = 1 to 4 do
    printf "  node[color=\"%s\", fillcolor=\"%s\", penwidth=4, style=\"filled\"];\n" (dark y) (light y);
    printf "\n";
    List.iter (print_module y) (List.filter (contains_major_theme target_theme) (modules_by_year y));
    printf "\n";
    printf "  node[penwidth=1];\n";
    printf "\n";
    List.iter (print_module y) (List.filter (contains_minor_theme target_theme) (modules_by_year y));
    printf "\n";
    printf "  node[color=\"%s\", fillcolor=\"%s\", style=\"dashed\"];\n" darkgrey lightgrey;
    printf "\n";
    List.iter (print_module y) (List.filter (fun m -> not (contains_theme target_theme m)) (modules_by_year y))
  done;
  if env_var_set "INCLUDEROOTNODE" then
    print_root_edges (modules_by_year 1) target_theme
  else (
    let title = match target_theme with
      | None -> "Module dependencies"
      | Some t -> sprintf "Module dependencies: %s theme" t
    in
    printf "  // title\n";
    printf "  labelloc=\"t\";\n";
    printf "  label=\"%s\";\n" title;
  );
  printf "}\n"

let target_theme : string option ref = ref None
  
let args_spec =
  [
    ("-theme", Arg.String (fun s -> target_theme := Some s),
     "theme (default is all themes)");
  ]
  
let usage = "Usage: builddot [options]\nOptions are:"
  
let _ =
  Arg.parse args_spec (fun _ -> ()) usage;
  main !target_theme
