## 1. 数据层实现

- [ ] 1.1 创建 `rescue_scorpion_stage` 配置表（stage_id, tasks[], timer_duration, spine_path）
- [ ] 1.2 创建 `rescue_scorpion_task` 配置表（task_id, condition, target, reward, description）
- [ ] 1.3 修改 `function_level` 表，新增拯救魔蝎功能解锁条件

## 2. 模块层实现

- [ ] 2.1 创建 `RescueScorpionModule` 继承 `FunctionModule`
- [ ] 2.2 创建 `RescueScorpionData` 处理玩家进度和倒计时
- [ ] 2.3 实现模块生命周期：初始化、激活、重置、销毁

## 3. UI层实现

- [ ] 3.1 创建 `RescueScorpionEntryView` 入口组件（显示图标+倒计时）
- [ ] 3.2 参考 `DailyQuestUI` 创建 `RescueScorpionMainView` 主界面（任务列表+倒计时+奖励）
- [ ] 3.3 参考 `TaskItem` 创建 `RescueScorpionTaskItem` 任务条目组件
- [ ] 3.4 实现Spine立绘加载（复用 `UISpine` 组件）

## 4. 倒计时系统实现

- [ ] 4.1 实现毫秒级倒计时（使用 `SLApp.Api.RegisterTimer(0.1f, ...)`）
- [ ] 4.2 实现离线超时处理（服务端记录 `stage_start_time`）
- [ ] 4.3 实现倒计时自动重新开始逻辑

## 5. 阶段任务系统实现

- [ ] 5.1 实现阶段解锁条件检查
- [ ] 5.2 参考 `DailyQuestData` 实现任务进度管理和状态更新
- [ ] 5.3 参考 `DailyQuestAbility.GetDailyRewardFunc` 实现任务奖励领取逻辑
- [ ] 5.4 实现阶段完成表现（刷新界面+减少阶段锁）

## 6. 红点系统集成

- [ ] 6.1 参考 `DailyQuestRedDotCheck` 创建 `RescueScorpionRedDotCheck` 实现红点逻辑
- [ ] 6.2 实现任务红点聚合到入口
- [ ] 6.3 集成到现有红点系统

## 7. 功能解锁集成

- [ ] 7.1 集成 `FuncCheckModule` 的解锁条件检查
- [ ] 7.2 实现击败虎先锋后入口解锁逻辑

## 8. 交互逻辑实现

- [ ] 8.1 实现任务"前往"按钮跳转功能
- [ ] 8.2 实现地图怪物任务的镜头移动逻辑
- [ ] 8.3 实现神将奖励的秀将界面调用
- [ ] 8.4 实现断网领取处理（参考 `ServerService.SendRequest`，允许点击，请求失败显示网络错误）

## 9. 测试与验证

- [ ] 9.1 编写单元测试：倒计时计算、阶段切换、任务进度
- [ ] 9.2 编写集成测试：入口解锁、红点映射、奖励发放
- [ ] 9.3 编写UI测试：倒计时显示、按钮状态、置灰效果
