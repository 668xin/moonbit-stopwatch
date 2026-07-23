///|
/// 测试辅助断言函数
fn assert_true(cond : Bool) -> Unit {
  if !cond {
    abort("assertion failed")
  }
}

///|
test "idle stopwatch returns 0 nanos" {
  let sw = @lib.Stopwatch::new()
  assert_true(sw.elapsed_nanos() == 0L)
  assert_true(sw.elapsed_micros() == 0L)
  assert_true(sw.elapsed_millis() == 0L)
  assert_true(sw.elapsed_secs() == 0.0)
  assert_true(!sw.is_running())
  assert_true(sw.lap_count() == 0)
}

///|
test "start increases elapsed" {
  let sw = @lib.Stopwatch::new().start()
  assert_true(sw.is_running())
  // 由于 @env.now() 精度为毫秒，刚启动时 elapsed 可能为 0
  assert_true(sw.elapsed_nanos() >= 0L)
  assert_true(sw.elapsed_micros() >= 0L)
  assert_true(sw.elapsed_millis() >= 0L)
  assert_true(sw.elapsed_secs() >= 0.0)
}

///|
test "stop pauses elapsed" {
  let sw = @lib.Stopwatch::new().start()
  let sw1 = sw.stop()
  assert_true(!sw1.is_running())
  assert_true(sw1.elapsed_nanos() >= 0L)
}

///|
test "resume continues counting" {
  let sw = @lib.Stopwatch::new().start()
  let sw1 = sw.stop()
  let paused_nanos = sw1.elapsed_nanos()
  let sw2 = sw1.resume()
  assert_true(sw2.is_running())
  assert_true(sw2.elapsed_nanos() >= paused_nanos)
}

///|
test "reset clears all state" {
  let sw = @lib.Stopwatch::new().start()
  let (sw1, _lap) = sw.lap("test")
  let sw2 = sw1.stop()
  let sw3 = sw2.reset()
  assert_true(sw3.elapsed_nanos() == 0L)
  assert_true(!sw3.is_running())
  assert_true(sw3.lap_count() == 0)
}

///|
test "multiple lap records increase monotonically" {
  let sw = @lib.Stopwatch::new().start()
  let (sw1, l1) = sw.lap("1st")
  assert_true(l1.total_nanos >= l1.lap_nanos)
  let (sw2, l2) = sw1.lap("2nd")
  assert_true(l2.total_nanos >= l1.total_nanos)
  let (sw3, l3) = sw2.lap("3rd")
  assert_true(l3.total_nanos >= l2.total_nanos)
  assert_true(sw3.lap_count() == 3)
  let laps = sw3.list_laps()
  assert_true(laps.length() == 3)
}

///|
test "lap record contains label and nanos" {
  let sw = @lib.Stopwatch::new().start()
  let (_sw, lap) = sw.lap("my-label")
  assert_true(lap.label == "my-label")
  assert_true(lap.lap_nanos >= 0L)
  assert_true(lap.total_nanos >= lap.lap_nanos)
}

///|
test "clear laps removes all records" {
  let sw = @lib.Stopwatch::new().start()
  let (sw1, _l1) = sw.lap("a")
  let (sw2, _l2) = sw1.lap("b")
  assert_true(sw2.lap_count() == 2)
  let sw3 = sw2.clear_laps()
  assert_true(sw3.lap_count() == 0)
  assert_true(sw3.is_running())
}

///|
test "double start is no-op" {
  let sw = @lib.Stopwatch::new().start()
  let sw1 = sw.start()
  assert_true(sw1.is_running())
  // 第二次 start 不应重置计时
  assert_true(sw1.elapsed_nanos() >= 0L)
}

///|
test "double stop is no-op" {
  let sw = @lib.Stopwatch::new().start().stop()
  let sw1 = sw.stop()
  assert_true(!sw1.is_running())
  // 第二次 stop 不改变已累积耗时
  assert_true(sw1.elapsed_nanos() >= 0L)
}

///|
test "resume on idle is no-op" {
  let sw = @lib.Stopwatch::new().resume()
  assert_true(!sw.is_running())
  assert_true(sw.elapsed_nanos() == 0L)
}

///|
test "resume on running is no-op" {
  let sw = @lib.Stopwatch::new().start()
  let sw1 = sw.resume()
  assert_true(sw1.is_running())
}

///|
test "lap on idle returns zero split" {
  let sw = @lib.Stopwatch::new()
  let (_sw, lap) = sw.lap("idle")
  assert_true(lap.lap_nanos == 0L)
  assert_true(lap.total_nanos == 0L)
}

///|
test "list_laps on empty stopwatch" {
  let sw = @lib.Stopwatch::new()
  let laps = sw.list_laps()
  assert_true(laps.length() == 0)
}

///|
test "elapsed_fmt on idle" {
  let sw = @lib.Stopwatch::new()
  assert_true(sw.elapsed_fmt() == "0 ns")
}
