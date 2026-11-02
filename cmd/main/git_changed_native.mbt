///|
#borrow(base, output_path)
#cfg(target="native")
extern "C" fn run_git_diff_command(base : Bytes, output_path : Bytes) -> Int = "moonbit_sqlsentinel_run_git_diff"

///|
#cfg(not(target="native"))
fn run_git_diff_command(base : Bytes, output_path : Bytes) -> Int {
  ignore(base)
  ignore(output_path)
  127
}
