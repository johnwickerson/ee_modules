open Format

let prepare_email to_recipients cc_recipients bcc_recipients sender_name sender_email subject body =
  let scpt_file = "mailer.scpt" in
  let oc = open_out scpt_file in
  let ocf = formatter_of_out_channel oc in
  fprintf ocf "tell application \"Mail\"\n";
  fprintf ocf "  set newMessage to make new outgoing message with properties {";
  fprintf ocf "sender:\"%s <%s>\", " sender_name sender_email;
  fprintf ocf "subject:\"%s\", " subject;
  fprintf ocf "content:\"%s\"}\n" body;
  fprintf ocf "  tell newMessage\n";
  fprintf ocf "    set visible to true\n";
  List.iter (fun recipient_email ->
      fprintf ocf "    make new to recipient at end of to recipients with ";
      fprintf ocf "properties {address:\"%s\"}\n" recipient_email;
    ) to_recipients;
  List.iter (fun cc ->
      fprintf ocf "    make new cc recipient at end of cc recipients with ";
      fprintf ocf "properties {address:\"%s\"}\n" cc
    ) cc_recipients;
  List.iter (fun bcc ->
      fprintf ocf "    make new bcc recipient at end of bcc recipients with ";
      fprintf ocf "properties {address:\"%s\"}\n" bcc;
    ) bcc_recipients;
  fprintf ocf "  end tell\n";
  (*fprintf ocf "activate\n";*)
  fprintf ocf "end tell\n";
  fprintf ocf "return \"%s: success.\"\n" scpt_file;
  close_out oc;
  (* Run the generated applescript. *)
  let _ = Sys.command (sprintf "osascript %s" scpt_file) in
  flush stdout

let rec iter_fun f n x =
  if n = 0 then x else f (iter_fun f (n-1) x)
  
let rec remdups = function
  | [] -> []
  | x :: xs -> (if List.mem x xs then [] else [x]) @ remdups xs

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

let as_yaml_string = function
  | `String s -> s
  | _ -> failwith "Expected a YAML string"

let as_yaml_number = function
  | `Float f -> f
  | _ -> failwith "Expected a YAML number"

let as_yaml_ordered_list = function
  | `O xs -> xs
  | _ -> failwith "Expected a YAML ordered list"
       
let as_yaml_dictionary = function
  | `A xs -> xs
  | _ -> failwith "Expected a YAML dictionary"
