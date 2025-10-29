Or-pattern under local open.

  $ bash ../test.sh <<'EOF'
  > module M = struct exception E end
  > let _ =
  >   match () with
  >   | () -> ()
  >   | M.(exception (E | Exit)) -> ()
  > EOF
