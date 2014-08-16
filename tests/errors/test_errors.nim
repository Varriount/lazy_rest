import lazy_rest, strutils, os

type Pair = tuple[src, dest: string]

const tests = ["unknown.rst", "rst_error.rst"]

proc test() =
  # First test without error control.
  for src in tests:
    let dest = src.change_file_ext("html")
    dest.write_file(src.safe_rst_file_to_html)
    doAssert dest.exists_file

when isMainModule:
  test()
  echo "Test finished successfully"
