(** The `read_config` symbol takes a string file path and creates a `Yaml.value`. If you just need a data structure and a few convenience functions to juggle YAML yourself, this will do the trick! (though it'd likely be much more straight forward to just install the `yaml` package and make the call to `Yaml_unix.of_file_exn Fpath.(v path)` yourself and decide where you do and don't want `option` types haha).

The `create_config` symbol is really where the scope narrows to a particular use case. It takes a `Yaml.value` (returned by `read_config`) and creates a couple data structures.

There's an example YAML file in this repo's [test/res/ directory](https://github.com/shnewto/lilac/tree/main/test/res). *)
open Base

(** Attempt to find key ~k in the yml object *)
let yaml_get_key ~k (yaml : Yaml.value option) = match yaml with
  | Some(`O assoc) -> Stdlib.List.assoc_opt k assoc
  | _ -> None

(** The string values pulled from the YAML definition have `\n` characters at the end, this gets rid of them. *)
let to_string_trim y =
    y |> Yaml.to_string_exn |> String.strip

(** Traverse ks list as yaml object and return the termonial state's value or None *)
let rec retrieve ~keys yaml =
    match keys with 
    | [e] -> yaml_get_key ~k:e yaml |> Option.map ~f:to_string_trim
    | h::t -> retrieve ~keys:t (yaml_get_key ~k:h yaml) 
    | _ -> None

(** 
Returns a string representatoin of the value of a given yaml field.
Example:
```
let yaml = yaml_from_fpath "test/res/config.yaml" in
  yaml_value ~path:"lilac-params.source.user" yaml 
  |> Option.value ~default:"Oops! It wasn't there." 
  |>  Stdio.print_endline;
```
 *)
let yaml_value_str ~path (yaml : Yaml.value) = 
    let keys = String.split path ~on:'.' in
    Some yaml |> retrieve ~keys:keys
    
(** Takes a file path and builds a Yaml.value *)
let yaml_from_fpath path =
    Yaml_unix.of_file_exn Fpath.(v path)

(** Something nice to have around. *)
let invite =
    "Come on. I'll open the wall for you."

(** Something else nice to have around. *)
let constellation = "\n\n\n         ✧\n       ✧\n                    ✧\n  ✧\n     ✧\n          ✧\n  ✧\n          ✧\n                   ✧\n           ✧\n   ✧\n                ✧\n                 ✧\n\n\n\n\n\n\n\n\n"
