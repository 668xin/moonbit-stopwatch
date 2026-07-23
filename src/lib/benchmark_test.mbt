///|
fn busy_work() -> Unit {
  for i in 0..<1000000 {
    let _x = i * i
  }
}

///|
test "BenchmarkConfig::new with valid params" {
  let cfg = BenchmarkConfig::new(5, 10)
  if !(cfg.warmup_times == 5) { abort("warmup_times should be 5") }
  if !(cfg.run_times == 10) { abort("run_times should be 10") }
}

///|
test "BenchmarkRunner::run returns reasonable results" {
  let cfg = BenchmarkConfig::new(2, 5)
  let runner = BenchmarkRunner::new(cfg)
  let result = runner.run(busy_work)
  if !(result.min_nanos >= 0L) { abort("min_nanos should be >= 0") }
  if !(result.min_nanos <= result.max_nanos) { abort("min should be <= max") }
  if !(result.avg_nanos <= result.max_nanos) { abort("avg should be <= max") }
  if !(result.total_nanos >= result.max_nanos) { abort("total should be >= max") }
  if !(result.total_nanos >= result.avg_nanos) { abort("total should be >= avg") }
}

///|
test "BenchmarkResult fields are populated correctly" {
  let cfg = BenchmarkConfig::new(1, 3)
  let runner = BenchmarkRunner::new(cfg)
  let result = runner.run(busy_work)
  if !(result.max_nanos >= result.min_nanos) { abort("max should be >= min") }
  if !(result.total_nanos >= result.max_nanos) { abort("total should be >= max") }
}

///|
test "print_table does not crash" {
  let cfg = BenchmarkConfig::new(1, 3)
  let runner = BenchmarkRunner::new(cfg)
  let result = runner.run(busy_work)
  print_table(result)
}
