///|
/// 分段记录
/// 存储单圈分段信息：标签名称、分段耗时（纳秒）、总耗时（纳秒）
pub struct LapRecord {
  label : String
  lap_nanos : Int64
  total_nanos : Int64
}
