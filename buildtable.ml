open Printf
open Yml_processor
open Jcommon
   
let themes_dict =
  let themes_csv_in = open_in "themes.csv" in
  let _column_headings = input_line themes_csv_in in
  let rec loop () =
    try
      let ln = input_line themes_csv_in in
      match Str.split (Str.regexp ",[ \t]*") ln with
      | [k;v;_email] -> (k,v) :: loop ()
      | _ -> failwith "Bad CSV file"
    with End_of_file ->
      close_in themes_csv_in; []
  in loop ()

let all_themes = List.map (fun (k,_) -> k) themes_dict

let description_of t = List.assoc t themes_dict

let term_index_of_module m =
  match startterm_of_module m, endterm_of_module m with
  | "autumn", "autumn" -> 0
  | "autumn", "spring" -> 1
  | "spring", "spring" -> 2
  | "spring", "summer" -> 3
  | "summer", "summer" -> 4
  | "autumn", "summer" -> 5
  | _, _ -> failwith "invalid term(s) provided"
                     
let print_module rowspan y m =
  let name = name_of_module m in
  let code = code_of_module m in
  let start_term = startterm_of_module m in
  let end_term = endterm_of_module m in
  let term =
    if start_term = end_term then
      start_term
    else
      sprintf "%s&dash;%s" start_term end_term
  in
  let stream = stream_of_module m in
  let is_eee, is_eie, is_eeem = match stream with
    | "both" -> true, true, true
    | "eie" -> false, true, false
    | "eee" -> true, false, true
    | "management" -> false, false, true
    | _ -> failwith "invalid stream"
  in
  let major_themes = major_themes_of_module m in
  let minor_themes = minor_themes_of_module m in
  printf "  <tr>\n";
  (match rowspan with
  | None -> ()
  | Some n -> printf "    <td rowspan=\"%d\">year %d</td>" n y);
  printf "    <td>%s</td>\n" term;
  printf "    <td>%s</td>\n" name;
  printf "    <td>%s</td>\n" (if is_eee then "&check;" else "");
  printf "    <td>%s</td>\n" (if is_eie then "&check;" else "");
  printf "    <td>%s</td>\n" (if is_eeem then "&check;" else "");
  printf "    <td>%s</td>\n" code;
  List.iter (fun t ->
      if List.mem t major_themes then
        printf "    <td class=\"major\">M</td>\n"
      else if List.mem t minor_themes then
        printf "    <td class=\"minor\">m</td>\n"
      else
        printf "<td></td>\n"
    )
    all_themes;
  printf "  </tr>\n"
                     
let main () =
  printf "<html>\n";
  printf "<head>\n";
  printf "<style>\n";
  printf "tr, td {\n";
  printf "  border: 1px solid black\n";
  printf "}\n";
  printf "td {\n";
  printf "  vertical-align: top\n";
  printf "}\n";
  printf "td.major {\n";
  printf "  background-color: #2ca25f;\n";
  printf "}\n";
  printf "td.minor {\n";
  printf "  background-color: #99d8c9;\n";
  printf "}\n";
  printf "th\n";
  printf "{\n";
  printf "  vertical-align: bottom;\n";
  printf "  text-align: center;\n";
  printf "}\n";
  printf "\n";
  printf "th span\n";
  printf "{\n";
  printf "  -ms-writing-mode: tb-rl;\n";
  printf "  -webkit-writing-mode: vertical-rl;\n";
  printf "  writing-mode: vertical-rl;\n";
  printf "  transform: rotate(180deg);\n";
  printf "  white-space: nowrap;\n";
  printf "}\n";
  printf "</style>\n";
  printf "</head>\n";
  printf "<body>\n";
  printf "<table>\n";
  printf "  <tr>\n";
  printf "    <td class=\"major\">M</td>\n";
  printf "    <td>major theme</td>\n";
  printf "  </tr>\n";
  printf "  <tr>\n";
  printf "    <td class=\"minor\">m</td>\n";
  printf "    <td>minor theme</td>\n";
  printf "  </tr>\n";
  printf "</table>\n";
  printf "<table>\n";
  printf "  <tr>\n";
  printf "    <th colspan=\"3\">EE Undergraduate Module Map</th>\n";
  printf "    <th><span>EEE</span></th>\n";
  printf "    <th><span>EIE</span></th>\n";
  printf "    <th><span>EEEM</span></th>\n";
  printf "    <th></th>\n";
  List.iter (fun t ->
      printf "    <th><span>%s</span></th>\n" (description_of t))
    all_themes;
  printf "  </tr>\n";
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  let all_modules = as_yaml_dictionary yml_top in
  let year_of_module_is y m = year_of_module m = float_of_int y in
  let modules_by_year y = List.filter (year_of_module_is y) all_modules in
  for y = 1 to 4 do
    let ms = modules_by_year y in
    let cmp m1 m2 = compare (term_index_of_module m1) (term_index_of_module m2) in
    let ms = List.sort cmp ms in
    print_module (Some (List.length ms)) y (List.hd ms);
    List.iter (print_module None y) (List.tl ms);
    printf "\n"
  done;
  printf "</table>\n";
  printf "</body>\n";
  printf "</html>\n"
  

let args_spec = []
   
let usage = "Usage: buildtable [options]\nOptions are:"
  
let _ =
  Arg.parse args_spec (fun _ -> ()) usage;
  main ()
