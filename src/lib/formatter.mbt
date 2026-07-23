///|
/// 格式化时间为 HH:MM:SS.mmm 可读字符串
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
