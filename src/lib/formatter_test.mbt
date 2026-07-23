///|
test "format_nanos: nanoseconds" {
  let result = @lib.format_nanos(500L)
  if !(result == "500 ns") { abort("expected '500 ns', got " + result) }
  let result2 = @lib.format_nanos(0L)
  if !(result2 == "0 ns") { abort("expected '0 ns', got " + result2) }
  let result3 = @lib.format_nanos(999L)
  if !(result3 == "999 ns") { abort("expected '999 ns', got " + result3) }
}

///|
test "format_nanos: microseconds" {
  let result = @lib.format_nanos(1500L)
  if !(result == "1 μs") { abort("expected '1 μs', got " + result) }
  let result2 = @lib.format_nanos(1_000L)
  if !(result2 == "1 μs") { abort("expected '1 μs', got " + result2) }
  let result3 = @lib.format_nanos(999_999L)
  if !(result3 == "999 μs") { abort("expected '999 μs', got " + result3) }
}

///|
test "format_nanos: milliseconds" {
  let result = @lib.format_nanos(1_500_000L)
  if !(result == "1.5 ms") { abort("expected '1.5 ms', got " + result) }
  let result2 = @lib.format_nanos(1_000_000L)
  if !(result2 == "1 ms") { abort("expected '1 ms', got " + result2) }
}

///|
test "format_nanos: seconds" {
  let result = @lib.format_nanos(1_500_000_000L)
  if !(result == "1.5 s") { abort("expected '1.5 s', got " + result) }
  let result2 = @lib.format_nanos(1_000_000_000L)
  if !(result2 == "1 s") { abort("expected '1 s', got " + result2) }
  let result3 = @lib.format_nanos(3_600_000_000_000L)
  if !(result3 == "3600 s") { abort("expected '3600 s', got " + result3) }
}

///|
test "format_time: HH:MM:SS.mmm" {
  if !(@lib.format_time(0.0) == "00:00:00.000") { abort("format_time(0) failed") }
  if !(@lib.format_time(5.5) == "00:00:05.500") { abort("format_time(5.5) failed") }
  if !(@lib.format_time(65.25) == "00:01:05.250") { abort("format_time(65.25) failed") }
  if !(@lib.format_time(3661.123) == "01:01:01.123") { abort("format_time(3661.123) failed") }
  if !(@lib.format_time(7322.456) == "02:02:02.456") { abort("format_time(7322.456) failed") }
}

///|
test "elapsed_fmt on Stopwatch" {
  let sw = @lib.Stopwatch::new()
  if !(sw.elapsed_fmt() == "0 ns") { abort("idle elapsed_fmt should be '0 ns'") }
  let sw1 = sw.start()
  let fmt = sw1.elapsed_fmt()
  if !(fmt.length() > 0) { abort("elapsed_fmt should not be empty") }
}

///|
test "format_time: large values" {
  if !(@lib.format_time(86400.0) == "24:00:00.000") { abort("format_time(86400) failed") }
  if !(@lib.format_time(100000.0) == "27:46:40.000") { abort("format_time(100000) failed") }
}

///|
test "format_nanos: boundary transitions" {
  // 刚好1000ns -> 1 μs
  if !(@lib.format_nanos(1000L) == "1 μs") { abort("1000 ns -> μs failed") }
  // 刚好1_000_000ns -> 1 ms
  if !(@lib.format_nanos(1_000_000L) == "1 ms") { abort("1_000_000 ns -> ms failed") }
  // 刚好1_000_000_000ns -> 1 s
  if !(@lib.format_nanos(1_000_000_000L) == "1 s") { abort("1_000_000_000 ns -> s failed") }
}
