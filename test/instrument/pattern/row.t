Or-pattern instrumentation does not prevent row type generalization.

  $ bash ../test.sh <<'EOF'
  > type t = [ `A | `B ]
  > module M :
  > sig
  >   val f : [< t ] -> unit
  > end =
  > struct
  >   let f = function
  >     | `A | `B -> ()
  > end
  > EOF
