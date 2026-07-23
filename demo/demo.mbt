///|
/// 秒表演示入口
fn main {
  println("=== MoonBit Stopwatch Demos ===")
  println("")
  demo_basic_usage()
  println("")
  demo_multiple_laps()
  println("")
  demo_format_time()
  println("")
  println("=== All Demos Complete ===")
}

///|
/// 基本使用演示
fn demo_basic_usage() -> Unit {
  println("--- Basic Usage ---")

  let sw = @lib.Stopwatch::new()
  println("New stopwatch, running: " + sw.is_running().to_string())

  let sw1 = sw.start()
  println("After start, running: " + sw1.is_running().to_string())
  println("Elapsed (secs): " + sw1.elapsed_secs().to_string())

  let sw2 = sw1.stop()
  println("After stop, running: " + sw2.is_running().to_string())
  println("Elapsed_nanos: " + sw2.elapsed_nanos().to_string())

  let sw3 = sw2.reset()
  println("After reset, nanos: " + sw3.elapsed_nanos().to_string())
}

///|
/// 多圈计时演示
fn demo_multiple_laps() -> Unit {
  println("--- Multiple Laps ---")

  let sw = @lib.Stopwatch::new().start()
  println("Started stopwatch")

  let (sw1, lap1) = sw.lap("first")
  println("Lap 1: " + lap1.label() + " " + @lib.format_nanos(lap1.lap_nanos()))

  let (sw2, lap2) = sw1.lap("second")
  println("Lap 2: " + lap2.label() + " " + @lib.format_nanos(lap2.lap_nanos()))

  let (sw3, lap3) = sw2.lap("third")
  println("Lap 3: " + lap3.label() + " " + @lib.format_nanos(lap3.lap_nanos()))

  println("Total laps: " + sw3.lap_count().to_string())

  let laps = sw3.list_laps()
  let mut i = 0
  while i < laps.length() {
    let lap = laps[i]
    println(
      "  " +
      lap.label() +
      ": split=" +
      @lib.format_nanos(lap.lap_nanos()) +
      ", total=" +
      @lib.format_nanos(lap.total_nanos()),
    )
    i = i + 1
  }

  let sw4 = sw3.stop()
  println("Final time: " + @lib.format_nanos(sw4.elapsed_nanos()))
}

///|
/// 时间格式化演示
fn demo_format_time() -> Unit {
  println("--- Time Formatting ---")

  let test_times : Array[Double] = [0.0, 5.5, 30.0, 65.25, 3661.123, 7322.456]

  let mut i = 0
  while i < test_times.length() {
    let t = test_times[i]
    println("  " + t.to_string() + "s -> " + @lib.format_time(t))
    i = i + 1
  }

  println("--- Nanos Formatting ---")
  let test_nanos : Array[Int64] = [0L, 500L, 1500L, 500_000L, 2_500_000L, 1_500_000_000L]
  let mut j = 0
  while j < test_nanos.length() {
    let n = test_nanos[j]
    println("  " + n.to_string() + " -> " + @lib.format_nanos(n))
    j = j + 1
  }
}
