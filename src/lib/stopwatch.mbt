///|
/// 秒表状态
enum StopwatchState {
  Idle
  Running
  Stopped
}

///|
/// 秒表结构体
pub struct Stopwatch {
  state : StopwatchState
  start_time : Double
  accumulated_time : Double
  laps : Array[Lap]
  last_lap_time : Double
}

///|
/// 获取当前时间戳（秒）
/// 内部辅助函数
fn current_time() -> Double {
  (@env.now().reinterpret_as_int64().to_double()) / 1000.0
}

///|
/// 创建一个新的秒表
pub fn Stopwatch::new() -> Stopwatch {
  {
    state: Idle,
    start_time: 0.0,
    accumulated_time: 0.0,
    laps: [],
    last_lap_time: 0.0,
  }
}

///|
/// 获取已用时间（秒）
pub fn Stopwatch::elapsed(self : Stopwatch) -> Double {
  match self.state {
    Running => self.accumulated_time + (current_time() - self.start_time)
    _ => self.accumulated_time
  }
}

///|
/// 开始计时
pub fn Stopwatch::start(self : Stopwatch) -> Stopwatch {
  match self.state {
    Running => self
    _ => { ..self, state: Running, start_time: current_time() }
  }
}

///|
/// 停止计时
pub fn Stopwatch::stop(self : Stopwatch) -> Stopwatch {
  match self.state {
    Running => {
      let now : Double = current_time()
      { ..self, state: Stopped, accumulated_time: self.accumulated_time + (now - self.start_time) }
    }
    _ => self
  }
}

///|
/// 重置秒表
pub fn Stopwatch::reset(self : Stopwatch) -> Stopwatch {
  { ..self, state: Idle, start_time: 0.0, accumulated_time: 0.0, laps: [], last_lap_time: 0.0 }
}

///|
/// 记录一圈
pub fn Stopwatch::lap(self : Stopwatch) -> (Stopwatch, Int) {
  match self.state {
    Running => {
      let elapsed_total : Double = self.elapsed()
      let lap_time : Double = elapsed_total - self.last_lap_time
      let lap_index : Int = self.laps.length() + 1
      let new_lap : Lap = {
        index: lap_index,
        split_time: lap_time,
        total_time: elapsed_total,
      }
      ({ ..self, laps: self.laps + [new_lap], last_lap_time: elapsed_total }, lap_index)
    }
    _ => (self, 0)
  }
}

///|
/// 获取所有圈速记录
pub fn Stopwatch::get_laps(self : Stopwatch) -> Array[Lap] {
  self.laps
}

///|
/// 获取圈数
pub fn Stopwatch::lap_count(self : Stopwatch) -> Int {
  self.laps.length()
}

///|
/// 检查是否正在运行
pub fn Stopwatch::is_running(self : Stopwatch) -> Bool {
  match self.state {
    Running => true
    _ => false
  }
}
