///|
/// 异步计时器
///
/// 基于 Stopwatch 实现异步任务计时 API。
///
/// 示例：
/// ```
/// let timer = AsyncTimer::new()
/// let timer = timer.start()
/// // ... async task ...
/// let (timer, elapsed) = timer.stop()
/// ```

///|
/// AsyncTimer 实例，用于测量异步任务的执行耗时
pub struct AsyncTimer {
  stopwatch : Stopwatch
}

///|
/// 创建新的异步计时器（未启动）
pub fn AsyncTimer::new() -> AsyncTimer {
  AsyncTimer::{ stopwatch: Stopwatch::new() }
}

///|
/// 启动异步计时器
pub fn AsyncTimer::start(self : AsyncTimer) -> AsyncTimer {
  AsyncTimer::{ stopwatch: self.stopwatch.start() }
}

///|
/// 停止异步计时器并返回 (新实例, 耗时纳秒)
pub fn AsyncTimer::stop(self : AsyncTimer) -> (AsyncTimer, Int64) {
  let sw = self.stopwatch.stop()
  let elapsed = sw.elapsed_nanos()
  (AsyncTimer::{ stopwatch: sw }, elapsed)
}

///|
/// 重置异步计时器
pub fn AsyncTimer::reset(self : AsyncTimer) -> AsyncTimer {
  AsyncTimer::{ stopwatch: self.stopwatch.reset() }
}
