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
      | [k;v] -> (k,v) :: loop ()
      | _ -> failwith "Bad CSV file"
    with End_of_file ->
      close_in themes_csv_in; []
  in loop ()

let all_themes = List.map (fun (k,_) -> k) themes_dict

let description_of t = List.assoc t themes_dict

let print_module rowspan y m =
  let name = name_of_module m in
  let code = code_of_module m in
  let major_themes = major_themes_of_module m in
  let minor_themes = minor_themes_of_module m in
  printf "  <tr>\n";
  (match rowspan with
  | None -> ()
  | Some n -> printf "    <td rowspan=\"%d\">year %d</td>" n y);
  printf "    <td>%s</td>\n" name;
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
  printf "    <th colspan=\"2\">EE Undergraduate Module Map</td>\n";
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
