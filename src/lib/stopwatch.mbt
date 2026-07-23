///|
/// 圈速记录
struct Lap {
  index : Int
  split_time : Double
  total_time : Double
}

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
  mut last_lap_time : Double
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
/// 获取当前时间戳（秒）
/// 内部辅助函数
fn current_time() -> Double {
  @env.now() / 1000.0
}

///|
/// 获取已用时间（秒）
pub fn Stopwatch.elapsed(self : Stopwatch) -> Double {
  match self.state {
    Running => self.accumulated_time + (current_time() - self.start_time)
    _ => self.accumulated_time
  }
}

///|
/// 开始计时
pub fn Stopwatch.start(self : Stopwatch) -> Stopwatch {
  match self.state {
    Running => self
    _ => {
      ..self
      state: Running,
      start_time: current_time(),
    }
  }
}

///|
/// 停止计时
pub fn Stopwatch.stop(self : Stopwatch) -> Stopwatch {
  match self.state {
    Running => {
      let now = current_time()
      {
        ..self
        state: Stopped,
        accumulated_time: self.accumulated_time + (now - self.start_time),
      }
    }
    _ => self
  }
}

///|
/// 重置秒表
pub fn Stopwatch.reset(self : Stopwatch) -> Stopwatch {
  {
    ..self
    state: Idle,
    start_time: 0.0,
    accumulated_time: 0.0,
    laps: [],
    last_lap_time: 0.0,
  }
}

///|
/// 记录一圈
pub fn Stopwatch.lap(self : Stopwatch) -> (Stopwatch, Int) {
  match self.state {
    Running => {
      let elapsed_total = self.elapsed()
      let lap_time = elapsed_total - self.last_lap_time
      let lap_index = self.laps.length() + 1
      let new_lap = {
        index: lap_index,
        split_time: lap_time,
        total_time: elapsed_total,
      }
      (
        {
          ..self
          laps: self.laps + [new_lap],
          last_lap_time: elapsed_total,
        },
        lap_index,
      )
    }
    _ => (self, 0)
  }
}

///|
/// 获取所有圈速记录
pub fn Stopwatch.get_laps(self : Stopwatch) -> Array[Lap] {
  self.laps
}

///|
/// 获取圈数
pub fn Stopwatch.lap_count(self : Stopwatch) -> Int {
  self.laps.length()
}

///|
/// 检查是否正在运行
pub fn Stopwatch.is_running(self : Stopwatch) -> Bool {
  match self.state {
    Running => true
    _ => false
  }
}

///|
/// 格式化时间为 HH:MM:SS.mmm
pub fn format_time(seconds : Double) -> String {
  let total_ms = (seconds * 1000.0).floor().to_int()
  let hours = total_ms / 3600000
  let minutes = total_ms % 3600000 / 60000
  let secs = total_ms % 60000 / 1000
  let ms = total_ms % 1000

  let pad2 = fn(n : Int) -> String {
    if n < 10 {
      "0" + n.to_string()
    } else {
      n.to_string()
    }
  }

  let pad3 = fn(n : Int) -> String {
    if n < 10 {
      "00" + n.to_string()
    } else if n < 100 {
      "0" + n.to_string()
    } else {
      n.to_string()
    }
  }

  pad2(hours) + ":" + pad2(minutes) + ":" + pad2(secs) + "." + pad3(ms)
}
