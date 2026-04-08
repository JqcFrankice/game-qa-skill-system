## Why

游戏5分钟时（击败虎先锋后），需要增加一个1小时的目标感，提升5分钟-半小时的转化率。拯救魔蝎功能通过多阶段限时任务系统，为玩家提供明确的阶段目标和倒计时压力，驱动玩家持续游戏。

## What Changes

- 新增拯救魔蝎功能入口，位于任务面板上方
- 实现多阶段限时任务系统，完成上一阶段解锁下一阶段
- 每阶段独立倒计时（精确到毫秒实时变动）
- 全部阶段完成后自动发放大奖（含神将秀将动画）
- 红点系统集成，可领取时显示红点
- 离线超时处理：上线时继续计数（若离线期间结束则重新开始）
- 断网领取处理：允许点击领取，请求失败显示网络错误，重连后需重新点击

## Capabilities

### New Capabilities
- `rescue-scorpion-entry`: 拯救魔蝎入口功能，包括解锁条件、图标显示、倒计时显示
- `rescue-scorpion-stage`: 阶段任务系统，包括阶段配置、任务列表、进度管理
- `rescue-scorpion-timer`: 倒计时系统，支持毫秒级实时更新和离线超时处理

### Modified Capabilities
- `red-dot-system`: 需要支持拯救魔蝎任务红点映射至入口
- `task-panel`: 需要在任务面板上方预留入口区域

## Impact

- **数据层**: 新增 `rescue_scorpion_stage` 和 `rescue_scorpion_task` 配置表，修改 `function_level` 表
- **模块层**: 新增 `RescueScorpionModule`，依赖 `TaskModule`、`FuncCheckModule`、`RedDotService`
- **UI层**: 新增入口组件和主界面，复用 `UISpine` 组件
- **服务层**: 复用 `Timer` 系统，需支持毫秒级更新
