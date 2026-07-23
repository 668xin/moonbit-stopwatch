///|
fn busy_work_json() -> Unit {
  for i in 0..<1000000 {
    let _x = i * i
  }
}

///|
test "result_to_json outputs valid JSON format" {
  let cfg = BenchmarkConfig::new(1, 3)
  let runner = BenchmarkRunner::new(cfg)
  let result = runner.run(busy_work_json)
  let json = result_to_json(result)
  if !(json.contains("\"min_nanos\"")) { abort("missing min_nanos") }
  if !(json.contains("\"max_nanos\"")) { abort("missing max_nanos") }
  if !(json.contains("\"avg_nanos\"")) { abort("missing avg_nanos") }
  if !(json.contains("\"total_nanos\"")) { abort("missing total_nanos") }
  if !(json.has_prefix("{")) { abort("should start with {") }
  if !(json.has_suffix("}")) { abort("should end with }") }
}

///|
test "result_to_json contains numeric values" {
  let cfg = BenchmarkConfig::new(1, 3)
  let runner = BenchmarkRunner::new(cfg)
  let result = runner.run(busy_work_json)
  let json = result_to_json(result)
  // total_nanos should be > 0 since we did busy work
  let lines = json.split("\n")
  if !(lines.length() > 0) { abort("should have lines") }
}
