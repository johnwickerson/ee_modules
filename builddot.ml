let _ =
  let yml_top = Yaml_unix.of_file_exn Fpath.(v "modules.yml") in
  match Yaml.to_string yml_top with
  | Result.Ok str -> Printf.printf "%s\n" str
  | _ -> failwith "Couldn't convert yml to string"
           
