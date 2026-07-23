///|
/// 将 BenchmarkResult 序列化为 JSON 字符串
///
/// 输出格式：
/// {
///   "min_nanos": 10,
///   "max_nanos": 100,
///   "avg_nanos": 50,
///   "total_nanos": 250
/// }
pub fn result_to_json(res : BenchmarkResult) -> String {
  let min = res.min_nanos.to_string()
  let max = res.max_nanos.to_string()
  let avg = res.avg_nanos.to_string()
  let total = res.total_nanos.to_string()
  let lines = [
    "{",
    "  \"min_nanos\": " + min + ",",
    "  \"max_nanos\": " + max + ",",
    "  \"avg_nanos\": " + avg + ",",
    "  \"total_nanos\": " + total,
    "}",
  ]
  lines.join("\n")
}
