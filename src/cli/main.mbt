///|
/// 秒表命令行工具
///
/// Usage:
///   stopwatch [options]
///
/// Options:
///   --demo               运行演示
///   --help, -h           显示帮助信息
fn main {
  let args = @env.args()
  let mut show_demo = false
  let mut show_help = false
  let mut i = 1

  while i < args.length() {
    let arg = args[i]
    if arg == "--demo" {
      show_demo = true
    } else if arg == "--help" || arg == "-h" {
      show_help = true
    }
    i = i + 1
  }

  if show_help || args.length() <= 1 {
    print_usage()
    return
  }

  if show_demo {
    run_demo()
  }
}

///|
/// 运行秒表演示
fn run_demo() -> Unit {
  println("=== MoonBit Stopwatch Demo ===")
  println("")

  let sw = @lib.Stopwatch::new()
  println("Created stopwatch: idle")
  println("Formatted time: " + @lib.format_time(sw.elapsed()))
  println("")

  let sw1 = sw.start()
  println("Started: running = " + sw1.is_running().to_string())

  let elapsed1 = sw1.elapsed()
  println("Elapsed: " + elapsed1.to_string() + "s")
  println("Formatted: " + @lib.format_time(elapsed1))
  println("")

  let (sw2, lap1) = sw1.lap()
  println("Lap " + lap1.to_string() + " recorded")
  println("Total laps: " + sw2.lap_count().to_string())
  println("")

  let sw3 = sw2.stop()
  println("Stopped: running = " + sw3.is_running().to_string())
  let elapsed2 = sw3.elapsed()
  println("Final elapsed: " + @lib.format_time(elapsed2))
  println("")

  let sw4 = sw3.reset()
  println("Reset: elapsed = " + sw4.elapsed().to_string() + "s")
  println("Laps after reset: " + sw4.lap_count().to_string())
  println("")
  println("=== Demo Complete ===")
}

///|
/// 打印使用帮助
fn print_usage() -> Unit {
  println("moonbit-stopwatch - MoonBit Stopwatch CLI Tool")
  println("")
  println("Usage:")
  println("  stopwatch [options]")
  println("")
  println("Options:")
  println("  --demo          Run stopwatch demo")
  println("  --help, -h      Show this help")
  println("")
  println("Examples:")
  println("  stopwatch --demo")
}
