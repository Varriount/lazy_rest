import lazy_rest, strutils, os

type Pair = tuple[src, dest: string]

const tests = ["unknown.rst", "rst_error.rst", "evil_asterisks.rst"]

proc test() =
  # First test without error control.
  for src in tests:
    let dest = src.change_file_ext("html")
    dest.write_file(src.safe_rst_file_to_html)
    do_assert dest.exists_file

  # Now do some in memory checks.
  discard safe_rst_file_to_html(nil)
  discard safe_rst_file_to_html("")
  discard safe_rst_string_to_html(nil, "Or was it `single quotes?")
  discard safe_rst_string_to_html("<", "Or was < it `single quotes?")
  try: discard safe_rst_string_to_html(nil, nil)
  except EAssertionFailed: discard

  var errors: seq[string]
  # Repeat counting errors.
  for src in tests:
    let dest = src.change_file_ext("html")
    errors = @[]
    dest.write_file(src.safe_rst_file_to_html(errors.addr))
    do_assert dest.exists_file
    do_assert errors.len > 0
    echo "Ignore this: ", errors[0]

  # Now do some in memory checks.
  errors = @[]
  discard safe_rst_file_to_html(nil, errors.addr)
  do_assert errors.len > 0
  echo "Ignore this: ", errors[0]
  errors = @[]
  discard safe_rst_file_to_html("", errors.addr)
  do_assert errors.len > 0
  echo "Ignore this: ", errors[0]
  errors = @[]
  discard safe_rst_string_to_html(nil, "Or was it `single quotes?")
  do_assert errors.len < 1
  discard safe_rst_string_to_html("<", "Or was < it `single quotes?")
  do_assert errors.len < 1


proc docstrings() =
  ## Stuff demostrated in the embedded documentation.
  const rst = "hello `world"
  discard safe_rst_string_to_html(nil, rst)
  var errors: seq[string] = @[]
  let html = safe_rst_string_to_html(nil, rst, errors.addr)
  if errors.len > 0: discard
  else: discard

  const rst_filename = "invisible.rst"
  discard safe_rst_file_to_html(rst_filename)
  errors = @[]
  let html2 = safe_rst_file_to_html(rst_filename, errors.addr)
  if errors.len > 0: discard
  else: discard

when isMainModule:
  test()
  docstrings()
  echo "Test finished successfully"
