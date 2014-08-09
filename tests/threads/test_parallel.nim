import lazy_rest, strutils, os, times, actors, osproc

type
  Param_in = tuple[src, dest: string]

const
  num_files = 10
  manual_input = "nimrod_doc"/"manual.txt"

proc process(p: Param_in) {.thread.} =
  # Converts the rst to html.
  p.dest.write_file(safe_rst_file_to_html(p.src))

proc serial_test() =
  for i in 1 .. num_files:
    process((manual_input, "smanual" & $i & ".html"))


proc parallel_test() =
  let cpus = countProcessors()
  echo "Using cpu pool: ", cpus
  var params: seq[Param_in] = @[]
  for i in 1 .. num_files:
    params.add((manual_input, "pmanual" & $i & ".html"))

  var pool: TActorPool[Param_in, void]
  pool.createActorPool(cpus)
  for i in 1 .. num_files:
    pool.spawn(params[i - 1], process)
  pool.sync()


proc test() =
  let t1 = epoch_time()
  serial_test()
  let t2 = epoch_time()
  parallel_test()
  let t3 = epoch_time()
  echo "Spent in serial queue ", $(t2 - t1)
  echo "Spent in parallel queue ", $(t3 - t2)

proc check_setup() =
  if not manual_input.exists_file:
    quit("Sorry, couldn't find " & manual_input &", copy it from NIM_PATH/doc.")

when isMainModule:
  check_setup()
  test()
  echo "Test finished successfully"
