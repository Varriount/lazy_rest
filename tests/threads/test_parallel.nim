import lazy_rest, strutils, os, times

const
  num_files = 10
  manual_input = "nimrod_doc"/"manual.txt"

proc process(src, dest: string) =
  # Converts the rst to html.
  dest.write_file(safe_rst_file_to_html(src))

proc serial_test() =
  for i in 1 .. num_files:
    process("nimrod_doc/manual.txt", "manual" & $i & ".html")

proc test() =
  let t1 = epoch_time()
  serial_test()
  let t2 = epoch_time()
  echo "Spent in serial queue ", $(t2 - t1)

proc check_setup() =
  if not manual_input.exists_file:
    quit("Sorry, couldn't find " & manual_input &", copy it from NIM_PATH/doc.")

when isMainModule:
  check_setup()
  test()
  echo "Test finished successfully"
