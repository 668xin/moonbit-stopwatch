///|
/// 格式化纳秒为可读字符串
///
/// 自动单位切换规则：
/// - < 1000 ns → ns
/// - < 1_000_000 ns → μs
/// - < 1_000_000_000 ns → ms
/// - ≥ 1_000_000_000 ns → s，保留2位小数
pub fn format_nanos(nanos : Int64) -> String {
  if nanos < 1000L {
    nanos.to_string() + " ns"
  } else if nanos < 1_000_000L {
    let us = (nanos / 1000L).to_int()
    us.to_string() + " μs"
  } else if nanos < 1_000_000_000L {
    let ms_val = nanos.to_double() / 1_000_000.0
    let ms = (ms_val * 100.0).floor() / 100.0
    ms.to_string() + " ms"
  } else {
    let s_val = nanos.to_double() / 1_000_000_000.0
    let s = (s_val * 100.0).floor() / 100.0
    s.to_string() + " s"
  }
}

///|
/// 格式化秒数为 HH:MM:SS.mmm 可读字符串
pub fn format_time(seconds : Double) -> String {
  let total_ms = (seconds * 1000.0).floor().to_int()
  let hours = total_ms / 3600000
  let minutes = total_ms % 3600000 / 60000
  let secs = total_ms % 60000 / 1000
  let ms = total_ms % 1000

  let pad2 = fn(n : Int) -> String {
    if n < 10 { "0" + n.to_string() } else { n.to_string() }
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
