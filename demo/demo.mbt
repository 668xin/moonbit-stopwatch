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
  println("Elapsed: " + @lib.format_time(sw1.elapsed()))

  let sw2 = sw1.stop()
  println("After stop, running: " + sw2.is_running().to_string())
  println("Elapsed: " + @lib.format_time(sw2.elapsed()))

  let sw3 = sw2.reset()
  println("After reset, elapsed: " + @lib.format_time(sw3.elapsed()))
}

///|
/// 多圈计时演示
fn demo_multiple_laps() -> Unit {
  println("--- Multiple Laps ---")

  let sw = @lib.Stopwatch::new().start()
  println("Started stopwatch")

  let (sw1, lap1) = sw.lap()
  println("Lap " + lap1.to_string() + " recorded")

  let (sw2, lap2) = sw1.lap()
  println("Lap " + lap2.to_string() + " recorded")

  let (sw3, lap3) = sw2.lap()
  println("Lap " + lap3.to_string() + " recorded")

  println("Total laps: " + sw3.lap_count().to_string())

  let laps = sw3.get_laps()
  let mut i = 0
  while i < laps.length() {
    let lap = laps[i]
    println(
      "  Lap " +
      lap.index.to_string() +
      ": split=" +
      @lib.format_time(lap.split_time) +
      ", total=" +
      @lib.format_time(lap.total_time),
    )
    i = i + 1
  }

  let sw4 = sw3.stop()
  println("Final time: " + @lib.format_time(sw4.elapsed()))
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
}
