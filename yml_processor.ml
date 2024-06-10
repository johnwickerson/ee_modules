open Jcommon

let field_of_module m f =
  lookup_exn (as_yaml_ordered_list m) f

let string_field_of_module m f =
  as_yaml_string (field_of_module m f)

let number_field_of_module m f =
  as_yaml_number (field_of_module m f)

let string_list_field_of_module m f =
  let xs = 
    try as_yaml_dictionary (field_of_module m f)
    with Not_found -> []
  in List.map as_yaml_string xs
   
let name_of_module m =
  string_field_of_module m "name"

let code_of_module m =
  string_field_of_module m "code"

let year_of_module m =
  number_field_of_module m "year"

let stream_of_module m =
  string_field_of_module m "stream"

let startterm_of_module m =
  try string_field_of_module m "startterm"
  with Not_found -> string_field_of_module m "term"

let endterm_of_module m =
  try string_field_of_module m "endterm"
  with Not_found -> string_field_of_module m "term"

let major_themes_of_module m =
  string_list_field_of_module m "major themes"

let minor_themes_of_module m =
  string_list_field_of_module m "minor themes"

let themes_of_module m =
  major_themes_of_module m @ minor_themes_of_module m

let prereqs_of_module m =
  string_list_field_of_module m "prereqs"
