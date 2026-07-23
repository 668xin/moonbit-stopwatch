///|
/// 分段记录
/// 存储单圈分段信息：标签名称、分段耗时（纳秒）、总耗时（纳秒）
pub struct LapRecord {
  priv label : String
  priv lap_nanos : Int64
  priv total_nanos : Int64
}

///|
/// 获取分段标签
pub fn LapRecord::label(self : LapRecord) -> String {
  self.label
}

///|
/// 获取本段耗时（纳秒）
pub fn LapRecord::lap_nanos(self : LapRecord) -> Int64 {
  self.lap_nanos
}

///|
/// 获取累计耗时（纳秒）
pub fn LapRecord::total_nanos(self : LapRecord) -> Int64 {
  self.total_nanos
}
