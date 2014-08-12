import lazy_rest, lazy_rest_pkg/lqueues

proc test() =
  var all = @[rst_file_task("something.rst"), rst_file_task("another.rst")]
  echo all

when isMainModule:
  test()
  echo "Test finished successfully"
