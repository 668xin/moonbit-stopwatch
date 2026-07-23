# moonbit-stopwatch 项目完整开发流程文档

> 文档用途：提供给AI辅助开发使用，明确阶段目标、模块划分、接口规范、验收标准、测试要求，所有功能严格对齐项目申报书，不得随意增删需求
> 项目名称：`moonbit-stopwatch`
> 开源协议：MIT
> 仓库地址：https://github.com/moonbit-community/moonbit-stopwatch.git

## 目录

1. 项目前置准备
2. 整体架构与模块划分
3. 分阶段开发任务
4. API 规范强制约束
5. 单元测试规范
6. 示例工程开发规范
7. 构建、打包、发布流程
8. 验收标准（对照申报书逐项校验）
9. README.md 撰写清单
10. AI开发强制约束

---

## 1. 项目前置准备

### 1.1 项目初始化命令

```bash
moon new moonbit-stopwatch
cd moonbit-stopwatch
# 初始化Git仓库，新增LICENSE文件，内容为MIT协议
# 修改 moon.mod.json 包名：github.com/moonbit-community/moonbit-stopwatch
```

### 1.2 依赖约束

仅允许引入依赖：

- `moonbitlang/core`（标准库，必选）
- `moonbitlang/async`（可选依赖，通过独立子包引入，不作为强制依赖）

## 2. 整体架构与模块职责

1. **stopwatch.mbt**
   管理计时器状态：未启动 / 运行中 / 暂停；实现启动、暂停、恢复、重置；提供多精度耗时读取接口。

2. **lap.mbt**
   存储分段记录：标签名称、分段耗时、时间戳；支持新增分段、遍历分段、清空分段。

3. **formatter.mbt**
   接收纳秒数值，自动匹配时间单位，输出可读性友好的时间字符串。

4. **benchmark.mbt**
   基准测试运行器，支持配置预热次数、正式迭代次数；计算最大、最小、平均耗时；控制台格式化表格输出结果。

5. **json_export.mbt**
   将基准测试统计结果序列化为JSON字符串，支持外部工具保存与可视化对比。

6. **async_timer.mbt**
   采用条件编译 `#[cfg(feature = "async")]`，基于 `moonbitlang/async` 实现异步任务计时API，无对应依赖时不参与编译。

7. **lib.mbt**
   统一导出所有对外公开类型、函数；内部实现全部标记为私有，隔离内部逻辑。

### 基础设计原则

- 不使用全局可变变量，所有能力基于实例调用；
- 统一使用 `moonbitlang/core/time::now_nanos()` 作为时钟源；
- 对外最小暴露原则，内部辅助方法添加 `priv` 修饰。

---

## 3. 分阶段开发任务

### 阶段1：基础 Stopwatch + Lap 分段功能（最高优先级）

**目标**：完成计时器核心逻辑，实现基础计时与分段打点

**开发文件**：

- src/stopwatch.mbt
- src/lap.mbt
- src/lib.mbt（基础类型导出）
- tests/stopwatch_test.mbt、tests/lap_test.mbt

**功能清单**：

1. 定义计时器状态枚举：Idle / Running / Paused
2. Stopwatch 核心方法：
   - `Stopwatch::start() -> Self` 创建并直接启动计时器
   - `new() -> Self` 创建未启动计时器实例
   - `start(&mut self)`
   - `stop(&mut self)`
   - `resume(&mut self)`
   - `reset(&mut self)`
3. 耗时读取接口：
   - `elapsed_nanos(&self) -> Int64`
   - `elapsed_micros(&self) -> Int64`
   - `elapsed_millis(&self) -> Int64`
   - `elapsed_secs(&self) -> Float64`
4. Lap 分段相关接口：
   - `lap(&mut self, label: String) -> LapRecord`
   - `list_laps(&self) -> Array[LapRecord]`
   - `clear_laps(&mut self)`

**单元测试覆盖场景**：

- 未启动状态读取耗时返回0
- 启动、暂停、恢复时序逻辑正确性
- 多次分段记录耗时单调递增
- reset清空计时器状态与所有分段记录

开发完成后编写示例：examples/basic_usage.mbt、examples/lap_demo.mbt

---

### 阶段2：时间格式化模块 formatter

**开发文件**：src/formatter.mbt、tests/formatter_test.mbt

**核心函数**：

```moonbit
format_nanos(nanos: Int64) -> String
```

**单位自动切换阈值规则**：

- < 1000ns → ns
- < 1_000_000ns → μs
- < 1_000_000_000ns → ms
- ≥ 1_000_000_000ns → s，数值保留2位小数

在Stopwatch新增便捷方法：`elapsed_fmt(&self) -> String`

---

### 阶段3：Benchmark 基准测试运行器

**开发文件**：src/benchmark.mbt、tests/benchmark_test.mbt

**核心结构体**：BenchmarkConfig、BenchmarkResult

**配置项**：

- warmup_times: Int 预热执行次数
- run_times: Int 正式迭代执行次数

**能力清单**：

1. `BenchmarkRunner::new(config) -> Self`
2. `run<F: () -> Unit>(&self, func: F) -> BenchmarkResult`
3. BenchmarkResult 字段：min_nanos、max_nanos、avg_nanos、total_nanos
4. `print_table(&result)` 控制台打印格式化表格
5. 参数边界保护，禁止迭代次数为0，给出友好提示

开发完成后编写示例：examples/bench_demo.mbt

---

### 阶段4：JSON导出、异步扩展、非法状态防护

1. **src/json_export.mbt**
   实现 `result_to_json(res: &BenchmarkResult) -> String`，输出标准JSON文本，用于数据持久化与外部绘图。

2. **src/async_timer.mbt**
   使用条件编译 `#[cfg(feature = "async")]`，依赖 `moonbitlang/async`，提供异步任务专用计时API。

3. **非法操作防护**
   处理重复start、重复stop、未启动直接resume等异常场景，不触发panic，做兼容处理。

---

### 阶段5：测试补齐、示例验证、API收敛

1. 补齐所有模块单元测试
2. 全部examples编译运行验证
3. 统一所有对外API，仅通过lib.mbt导出
4. 本地执行 `moon build`、`moon test`，保证全部通过

---

### 阶段6：发布准备

1. 完善LICENSE协议文件
2. 编写完整README.md
3. 配置moon.mod.json版本号
4. 推送代码至GitHub，验证 `moon pkg` 可正常拉取依赖

---

## 4. API 规范强制约束

1. **命名规范**
   - 类型名：UpperCamelCase，例如 `Stopwatch`
   - 函数、方法：snake_case，例如 `elapsed_nanos`

2. 所有内部辅助函数、结构体字段添加 `priv`，最小暴露原则

3. 禁止使用全局可变状态，计时器全部基于实例

4. 底层时间统一使用 Int64 存储纳秒，避免精度丢失

5. 公开结构体字段尽量私有化，通过方法访问，保障后续版本兼容性

6. 常规非法调用不使用panic，优雅处理边界情况

**标准API参考范式**：

```moonbit
pub struct Stopwatch {
  priv state: StopwatchState,
  priv start_ts: Int64,
  priv pause_acc: Int64,
  priv laps: Array[LapRecord],
}

pub impl Stopwatch {
  pub fn start() -> Self { ... }
  pub fn elapsed_nanos(&self) -> Int64 { ... }
  pub fn lap(&mut self, label: String) -> LapRecord { ... }
}
```

---

## 5. 单元测试规范

1. src目录下每个模块，对应tests目录下`*_test.mbt`测试文件
2. 测试用例必须覆盖正常流程 + 边界异常场景
3. 使用 `moon test` 一键执行全部测试
4. 耗时相关测试禁止写死固定数值，采用区间断言

> 错误示例：assert(sw.elapsed_nanos() == 123456)
> 正确示例：assert(sw.elapsed_nanos() > 0)

---

## 6. 示例工程开发规范

- examples下所有示例必须独立可编译运行；
- 示例代码简洁，重点展示对应功能用法，附带注释；
- 示例仅作为演示，不承担复杂业务逻辑。

---

## 7. 构建、打包、发布流程

```bash
# 本地构建
moon build

# 执行单元测试
moon test

# 本地运行示例
moon run examples/basic_usage.mbt

# 推送代码后，其他项目引入方式
moon add github.com/moonbit-community/moonbit-stopwatch
```

---

## 8. 验收标准（和申报书一一对应，开发完成逐项核对）

- [ ] Stopwatch计时器：启动、暂停、恢复、重置
- [ ] 支持纳秒、微秒、毫秒、秒多单位耗时获取
- [ ] Lap命名分段打点，支持保存多条分段记录
- [ ] 智能时间格式化输出
- [ ] Benchmark运行器，支持预热、多次迭代执行
- [ ] 统计计算：平均值、最大值、最小值
- [ ] 控制台表格打印基准测试结果
- [ ] Benchmark结果JSON序列化导出
- [x] 基于moonbitlang/async实现异步计时API（独立子包 async_timer）
- [ ] 非法状态边界逻辑处理
- [ ] 完整单元测试覆盖
- [ ] 4组可运行示例代码
- [ ] README包含快速上手、API示例代码
- [ ] 可编译独立CLI演示程序

---

## 9. README.md 撰写清单

1. 项目简介（精简申报书中项目描述）
2. 安装命令 `moon add github.com/moonbit-community/moonbit-stopwatch`
3. 基础Stopwatch使用示例
4. Lap分段打点示例
5. Benchmark基准测试示例
6. JSON导出示例
7. 异步计时启用方式（feature开关说明）
8. 核心API简要文档
9. 本地开发、测试命令
10. LICENSE协议说明

---

## 10. AI开发强制约束

```
强制开发约束：
1. 严格按照本文档目录结构创建文件，不随意新增、合并模块；
2. 所有对外API统一在 src/lib.mbt 集中导出；
3. 内部实现全部标记priv，遵循最小暴露原则；
4. 代码遵循MoonBit官方编码风格；
5. 每完成一个模块，同步编写对应单元测试；
6. 不引入任何未指定的第三方依赖；
7. 异步模块使用条件编译，不强制依赖 moonbitlang/async；
8. 禁止删减申报书中任何需求，所有列出功能必须完整实现；
9. 输出代码附带简单可运行demo；
10. 遇到设计疑问优先列出可选方案，不得擅自删减功能。
```
