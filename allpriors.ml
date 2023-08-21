open Format
open Jcommon

let code_of m =
  as_yaml_string (lookup_exn (as_yaml_ordered_list m) "code")

let leader_of m =
  as_yaml_string (lookup_exn (as_yaml_ordered_list m) "leader")

let name_of m =
  try as_yaml_string (lookup_exn (as_yaml_ordered_list m) "name")
  with Not_found -> failwith (sprintf "Name not specified for module %s" (code_of m))

let year_of m =
  try int_of_float (as_yaml_number (lookup_exn (as_yaml_ordered_list m) "year"))
  with Not_found -> failwith (sprintf "Year not specified for module %s" (code_of m))

let ilos_of m =
  try as_yaml_ordered_list (lookup_exn (as_yaml_ordered_list m) "ilos")
  with Not_found -> failwith (sprintf "ILOs not specified for module %s" (code_of m))
    
let int_of_term_str = function
    "autumn" -> 0
  | "spring" -> 1
  | "summer" -> 2
  | s -> failwith (sprintf "Unrecognised term '%s'" s)
       
let startterm_str m =
  try as_yaml_string (lookup_exn (as_yaml_ordered_list m) "startterm")
  with Not_found -> failwith (sprintf "Start term not specified for module %s" (code_of m))

let endterm_str m =
  try as_yaml_string (lookup_exn (as_yaml_ordered_list m) "endterm")
  with Not_found -> failwith (sprintf "End term not specified for module %s" (code_of m))

let startterm_of m =
  let y = year_of m in
  (y-1)*3 + int_of_term_str (startterm_str m) + 1
  
let endterm_of m =
  let y = year_of m in
  (y-1)*3 + int_of_term_str (endterm_str m) + 1
   
let compare_by_endterm m1 m2 =
  let e1 = endterm_of m1 in
  let e2 = endterm_of m2 in
  compare e1 e2

let print_module oc m =
  let c = code_of m in
  let n = name_of m in
  fprintf oc "  - %s (%s)\n" c n
  
let print_module_with_ilos oc m =
  let c = code_of m in
  let n = name_of m in
  let ilos = ilos_of m in
  fprintf oc "\n";
  fprintf oc "=================\n";
  fprintf oc "%s (%s)\n" c n;
  fprintf oc "-----------------\n";
  List.iter (fun (i,ilo) -> fprintf oc "%s.%s: %s\n" c i (as_yaml_string ilo)) ilos
  
let allpriors my_code =
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  let all_modules = as_yaml_dictionary yml_top in
  let my_module =
    try List.find (fun m -> code_of m = my_code) all_modules
    with Not_found -> failwith (sprintf "Unknown module code '%s'" my_code)
  in
  let all_modules = List.sort compare_by_endterm all_modules in
  let my_startterm = startterm_of my_module in
  let prior_modules = List.filter (fun m -> endterm_of m < my_startterm) all_modules in

  let email = leader_of my_module in
  
  let b = Buffer.create 100 in
  let oc = formatter_of_buffer b in
  fprintf oc "Hello,\n\n";
  fprintf oc "The DUGS team (Christos, Adrià, and myself) would like to better understand how our various modules build upon each other.\n\n";
  fprintf oc "As you are the leader of module %s (%s), I'd appreciate your help with this task.\n\n" my_code (name_of my_module);
  fprintf oc "It should only take you a couple of minutes.\n\n";
  fprintf oc "Below is a list of all the modules (including compulsory and optional modules) that have finished by the time your module starts.\n\n";
  List.iter (print_module oc) prior_modules;
  fprintf oc "\n";
  fprintf oc "Could you please tell me which of those modules your module builds upon?\n\n";
  fprintf oc "To help you answer this, I've also listed the intended learning outcomes (ILOs) of each module, below. Each ILO has a unique identifier; for instance, 'ELEC40002.2' is the second ILO of module ELEC40002.\n\n";
  fprintf oc "If you could have a quick read through these ILOs and reply to me with a message like 'My module builds on ELEC40002.2, ELEC40003.4, and ELEC40004.3', then that would be fantastic.\n\n";
  fprintf oc "Many thanks, and best wishes,\n\n";
  fprintf oc "John\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
  List.iter (print_module_with_ilos oc) prior_modules;
  fprintf oc "\n";
  pp_print_flush oc ();
  let email_body = Buffer.contents b in
  let sender_name = "John Wickerson" in
  let sender_email = "j.wickerson@imperial.ac.uk" in
  let subject = "Question about your module" in
  prepare_email [email] [] [] sender_name sender_email subject email_body

   
let _ =
   if Array.length Sys.argv <> 2 then
     failwith "Usage: `./allpriors <module code>`.";
   let my_code = Sys.argv.(1) in
   allpriors my_code
