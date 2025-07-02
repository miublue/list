exception UnknownFlag of string;

val show_full_path = ref false
and list_recursive = ref false
and show_hidden = ref false
and list_dirs   = ref true
and list_files  = ref true
and path = ref ".";

fun get_file_name f = List.last (String.tokens (fn c => c = #"/") f)

fun print_help () =
    (print ("usage: " ^ get_file_name (CommandLine.name ()) ^ " [-h|-r|-p|-i|-f|-d] [path]\n");
    OS.Process.exit OS.Process.success);

fun parse_flags [] = ()
  | parse_flags (h::t) =
    (case h of
      #"h" => print_help ()
    | #"r" => list_recursive := true
    | #"d" => list_files := false
    | #"f" => list_dirs := false
    | #"i" => show_hidden := true
    | #"p" => show_full_path := true
    | s    => raise (UnknownFlag (Char.toString s));
    parse_flags t);

fun parse_args [] = ()
  | parse_args (h::t) =
    (if hd (explode h) = #"-"
    then parse_flags (tl (explode h))
    else path := OS.FileSys.fullPath h;
    parse_args t);

val _ = let
    (* XXX: allow printing with colors and file type/properties *)
    fun print_file full_path to_print =
        if OS.FileSys.isDir full_path
        then if (!list_dirs) then print (to_print ^ "/\n") else ()
        else if (!list_files) then print (to_print ^ "\n") else ();

    fun list_path path = let
        val stream = OS.FileSys.openDir (OS.FileSys.fullPath path);
        fun list_file file = let
            val full_path = OS.FileSys.fullPath (path ^ "/" ^ file);
            val to_print = if (!show_full_path) then full_path else file;
        in
            if hd (explode file) = #"." andalso not (!show_hidden)
            then () (* ignore dotfiles if not show_hidden *)
            else (print_file full_path to_print;
                  if OS.FileSys.isDir full_path andalso (!list_recursive)
                  then list_path full_path (* list recursively *)
                  else ())
        end handle OS.SysErr (s,_) => (); (* ignore files it cannot list *)

        fun list_next stream =
            case OS.FileSys.readDir stream of
              SOME file => (list_file file; list_next stream)
            | NONE => OS.FileSys.closeDir stream
    in
        list_next stream
    end;
in
    parse_args (CommandLine.arguments ());
    list_path (!path)
end handle OS.SysErr (s,_) => print ("error: " ^ s ^ "\n")
         | UnknownFlag s   => print ("error: unknown flag '-" ^ s ^ "'\n")

