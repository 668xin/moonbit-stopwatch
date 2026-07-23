/// 秒表库核心模块
/// 统一导出所有对外公开类型与函数
///
/// 模块划分：
/// - stopwatch.mbt — 秒表核心计时器
/// - lap.mbt — 分段记录
/// - formatter.mbt — 时间格式化
///
/// 使用示例：
/// ```
/// let sw = Stopwatch::new()
/// let sw1 = sw.start()
/// let elapsed = sw1.elapsed()
/// println(format_time(elapsed))
/// ```
