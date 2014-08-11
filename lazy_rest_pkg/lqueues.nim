## Multi processor aware API for `lazy_rest
## <https://github.com/gradha/lazy_rest>`_.
##
## By default the main `lazy_rest <../lazy_rest.html>`_ module works in a
## single threaded way. Since no globals are used, rendering of rst files can
## be parallelized. This module builds on top of the main API providing a queue
## interface: you pass a list of `Rest_task <#Rest_task>`_ objects and they
## will be rendered in parallel using all available cores.

import lazy_rest, external/badger_bits/bb_system, locks

type
  Rest_task* = object ## Holds input/output data for each rendering job. \
    ##
    ## You can create any number of rest tasks and populate the fields, then
    ## feed them to render and check the output.
    input_filename*: string ## Full path to the input filename. \
      ##
      ## This field can be left nil if you are providing the rst data to render
      ## in the `input_data` field. However, this is needed for documents using
      ## the include directive or reporting errors to users.
    input_data*: string ## Contents of the input filename. \
      ##
      ## This field can be nil if you are providing a filename in the
      ## `input_filename` field. But if this field is not nil, no IO operation
      ## will be done for rendering.
    output_data*: string ## Stores render result data. \
      ##
      ## This value will be nil if the Rest_task object has not been processed
      ## or there was a serious error preventing any rendering.
    output_filename*: string ## Fill path to the output filename. \
      ##
      ## This field can be left nil, in which case only `output_data` will be
      ## filled. However, if you provide a non nil string, it will be created
      ## or overwritten with the contents from `output_data`.
    safe_render*: bool ## Set this to true if you need safe rendering. \
      ##
      ## When safe rendering is active, you will **always** get a valid HTML in
      ## the `output_data` field. However, this might be an HTML error message
      ## if something actually went wrong, which tells the user to report bugs
      ## in GigHub along with a raw listing of the input file.
      ##
      ## When `safe_render` is false, `output_data` will be filled only if
      ## there were no errors of any kind during rendering.
    errors*: seq[string] ## List of errors found. \
      ##
      ## The list of errors found will be not nil if any errors were found.
      ## Note that not all kind of errors are critical. For instance, if you
      ## set up rendering of rst files and the target output files can't be
      ## written, you still have the valid data in the `output_data` field, but
      ## `errors` will contain a text description of an IO error. Also if you
      ## set `safe_render` to true, any rendering error will be added to this
      ## sequence.

  Rest_thread = TThread[void] ## Shortcut for void thread.

  Global_communication = object ## \
    ## Holds all the communication global variables between threads.
    L: TLock ## Global lock, used to avoid concurrent calls to public API.
    DL: TLock ## Data lock, used by consumer threads to access the queue.
    threads: seq[Rest_thread] ## Pool of created threads.
    tasks: seq[Rest_task] ## List of input/output tasks to process.
    pos: int ## Next `tasks` index to process by a Rest_thread.


var G: Global_communication


#when isMainModule:
#  writeFile("out.html", rst_file_to_html("test.rst"))
