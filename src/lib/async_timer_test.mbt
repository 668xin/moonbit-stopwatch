///|
/// 测试辅助断言函数
fn check(cond : Bool) -> Unit {
  if !cond {
    abort("assertion failed")
  }
}

///|
test "AsyncTimer::new creates idle timer" {
  let timer = AsyncTimer::new()
  let (_timer2, elapsed) = timer.stop()
  check(elapsed == 0L)
}

///|
test "AsyncTimer::start begins timing" {
  let timer = AsyncTimer::new().start()
  let (_timer2, elapsed) = timer.stop()
  check(elapsed >= 0L)
}

///|
test "AsyncTimer::reset clears elapsed time" {
  let timer = AsyncTimer::new().start()
  let (timer2, _elapsed) = timer.stop()
  let timer3 = timer2.reset()
  let (_timer4, elapsed) = timer3.stop()
  check(elapsed == 0L)
}

///|
test "AsyncTimer::stop returns elapsed >= 0" {
  let timer = AsyncTimer::new().start()
  let (_timer2, elapsed) = timer.stop()
  check(elapsed >= 0L)
}

///|
test "AsyncTimer double start is no-op" {
  let timer = AsyncTimer::new().start()
  let timer1 = timer.start()
  let (_timer2, elapsed) = timer1.stop()
  check(elapsed >= 0L)
}

///|
test "AsyncTimer double stop is no-op" {
  let timer = AsyncTimer::new().start()
  let (timer1, _e1) = timer.stop()
  let (timer2, e2) = timer1.stop()
  check(e2 == 0L)
}

///|
test "AsyncTimer stop on idle returns zero" {
  let timer = AsyncTimer::new()
  let (_timer, elapsed) = timer.stop()
  check(elapsed == 0L)
}

///|
test "AsyncTimer reset on running clears time" {
  let timer = AsyncTimer::new().start()
  let timer1 = timer.reset()
  let (_timer2, elapsed) = timer1.stop()
  check(elapsed == 0L)
}
