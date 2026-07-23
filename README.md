# moonbit-stopwatch

一个轻量级、高性能的秒表（Stopwatch）库，使用 [MoonBit](https://www.moonbitlang.com/) 语言构建。支持**精确计时**、**分段计时（Lap）**、**暂停/恢复**、**基准测试**和**JSON导出**等功能。

## 特性

- **精确计时** — 纳秒级精度，支持读取纳秒、微秒、毫秒、秒
- **暂停/恢复** — 可随时暂停计时，恢复后继续累积
- **分段计时（Lap）** — 记录多个分段，支持标签和自动累计
- **基准测试（Benchmark）** — 内置预热 + 多次运行 + 统计分析
- **格式化输出** — 自动智能单位切换（ns / μs / ms / s）
- **JSON 导出** — 将基准测试结果序列化为 JSON
- **异步计时** — 为异步任务提供 `AsyncTimer` 封装
- **不可变设计** — 所有操作返回新实例，无副作用

## 安装

在 `moon.mod` 中添加依赖：

```toml
[deps]
"668xin/moonbit-stopwatch" = "0.1.0"
```

或通过命令添加：

```bash
moon add 668xin/moonbit-stopwatch
```

## 快速开始

```moonbit
fn main {
  // 创建秒表
  let sw = @lib.Stopwatch::new()

  // 启动
  let sw1 = sw.start()

  // 读取耗时
  println("纳秒: {sw1.elapsed_nanos()}")
  println("毫秒: {sw1.elapsed_millis()}")
  println("格式化: {sw1.elapsed_fmt()}")

  // 暂停
  let sw2 = sw1.stop()

  // 恢复
  let sw3 = sw2.resume()

  // 重置
  let sw4 = sw3.reset()
}
```

## API 概览

### 核心类型 `Stopwatch`

```
┌─ Stopwatch ──────────────────────────────┐
│  Stopwatch::new()       创建未启动秒表     │
│  .start()               启动              │
│  .stop()                暂停              │
│  .resume()              恢复              │
│  .reset()               重置              │
│  .elapsed_nanos()       纳秒              │
│  .elapsed_micros()      微秒              │
│  .elapsed_millis()      毫秒              │
│  .elapsed_secs()        秒（浮点数）       │
│  .elapsed_fmt()         可读字符串         │
│  .is_running()          是否运行中         │
│  .lap(label)            记录分段           │
│  .list_laps()           获取所有分段       │
│  .clear_laps()          清空分段           │
│  .lap_count()           分段数量           │
└──────────────────────────────────────────┘
```

### 分段记录 `LapRecord`

```moonbit
pub struct LapRecord {
  label       : String   // 分段标签
  lap_nanos   : Int64    // 本段耗时（纳秒）
  total_nanos : Int64    // 累计耗时（纳秒）
}
```

### 基准测试

```moonbit
// 创建配置：预热5次，正式运行10次
let config = @lib.BenchmarkConfig::new(5, 10)
let runner = @lib.BenchmarkRunner::new(config)
let result = runner.run(fn() { /* 被测函数 */ })

// 打印结果
@lib.print_table(result)

// JSON 导出
let json = @lib.result_to_json(result)
```

### 格式化函数

```moonbit
// 纳秒格式化：自动单位切换
@lib.format_nanos(1500L)        // → "1 μs"
@lib.format_nanos(1_500_000L)   // → "1.5 ms"
@lib.format_nanos(1_500_000_000L) // → "1.5 s"

// 时间格式化：HH:MM:SS.mmm
@lib.format_time(3661.123)      // → "01:01:01.123"
```

### 异步计时 `AsyncTimer`

```moonbit
let timer = @lib.AsyncTimer::new()
let timer = timer.start()
// ... async task ...
let (timer, elapsed_ns) = timer.stop()
```

## 完整示例

- [basic_usage](examples/basic_usage/) — Stopwatch 基本使用
- [lap_demo](examples/lap_demo/) — 分段计时演示
- [bench_demo](examples/bench_demo/) — 基准测试演示
- [demo](demo/) — 综合演示（含 format_time 格式化）

运行示例：

```bash
moon run examples/basic_usage
moon run examples/lap_demo
moon run examples/bench_demo
moon run demo
```

## 开发

```bash
# 构建
moon build

# 测试
moon test

# 命令行工具
moon run src/cli -- --demo
```

## 许可证

[MIT](LICENSE) © 2026 668xin
