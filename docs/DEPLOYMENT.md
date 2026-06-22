# 华容道多端部署指南

## 📋 项目结构

重构后的项目采用分层架构：

```
HuaRongDao/
├── core/                    # 核心逻辑层（平台无关）
│   ├── src/
│   │   ├── managers/        # 游戏管理器
│   │   ├── models/          # 数据模型
│   │   ├── constants/       # 游戏常量
│   │   ├── data/            # 关卡数据
│   │   └── index.ts         # 导出
│   ├── package.json
│   └── tsconfig.json
│
├── platform/                # 平台适配层
│   ├── common/              # 通用接口
│   ├── harmonyos/           # HarmonyOS适配
│   ├── web/                 # Web适配
│   └── index.ts
│
├── ui/                      # UI层（各平台实现）
│   ├── harmonyos/           # HarmonyOS UI（当前）
│   ├── web/                 # Web UI（待实现）
│   ├── android/             # Android UI（待实现）
│   └── ios/                 # iOS UI（待实现）
│
└── scripts/                 # 构建脚本
    └── build.sh
```

## 🎯 核心特性

### 1. 平台无关的核心逻辑

✅ **已实现**：
- 游戏状态管理（GameStateManager）
- 移动验证算法（MoveValidator）
- 胜负判断（WinChecker）
- 关卡管理（LevelManager）
- 数据模型（Piece, Level, BoardState）
- 关卡配置数据（LevelData）

❌ **平台无关**：
- 不依赖任何平台API
- 纯TypeScript实现
- 可在任何JavaScript环境运行

### 2. 平台适配层

✅ **已定义接口**：
- IStorage - 存储接口
- IDevice - 设备信息接口
- IShare - 分享接口
- IToast - 提示接口

✅ **已实现适配器**：
- HarmonyOS适配器（HarmonyStorage, HarmonyDevice, HarmonyToast）
- Web适配器（WebStorage, WebDevice, WebToast）

### 3. 多端UI

✅ **HarmonyOS UI**：
- 已有完整的ArkUI实现
- 可直接使用核心层逻辑

🔄 **Web UI**：
- 需要使用React/Vue实现
- 引用核心层逻辑
- 实现响应式布局

## 🚀 快速开始

### 安装依赖

```bash
# 安装核心层依赖
cd core
npm install

# 构建核心层
npm run build
```

### 开发HarmonyOS版本

```bash
# 在DevEco Studio中打开项目
# ui/harmonyos目录

# 运行项目
hvigorw assembleHap
```

### 开发Web版本

```bash
# 创建Web项目
cd ui/web
npm install

# 开发模式
npm run dev

# 构建
npm run build
```

## 📱 平台特性

### HarmonyOS

**优势**：
- 原生性能
- 完整的设备能力
- 流畅的动画

**使用**：
```typescript
import { createHarmonyAdapter } from '@huarongdao/platform/harmonyos';

const adapter = createHarmonyAdapter();
adapter.toast.show('欢迎来到华容道！');
```

### Web

**优势**：
- 跨平台
- 快速开发
- 易于部署

**使用**：
```typescript
import { createWebAdapter } from '@huarongdao/platform/web';

const adapter = createWebAdapter();
adapter.toast.show('欢迎来到华容道！');
```

## 🔧 构建命令

```bash
# 构建核心层
./scripts/build.sh core

# 构建Web版本
./scripts/build.sh web

# 构建HarmonyOS版本
./scripts/build.sh harmonyos

# 构建所有平台
./scripts/build.sh all
```

## 📊 架构优势

### 1. 代码复用

- 核心逻辑只维护一份
- 各平台共享游戏算法
- 减少重复开发

### 2. 易于维护

- 清晰的分层结构
- 平台相关代码隔离
- 统一的接口定义

### 3. 灵活扩展

- 新增平台只需实现适配器
- UI层可自由选择技术栈
- 核心逻辑稳定不变

### 4. 测试友好

- 核心逻辑可独立测试
- 平台适配器可mock
- 单元测试覆盖率高

## 🎓 最佳实践

### 核心层开发

```typescript
// ❌ 错误：直接调用平台API
const width = window.innerWidth;

// ✅ 正确：使用平台适配器
const width = platformAdapter.device.getScreenWidth();
```

### 平台适配器使用

```typescript
// 获取平台适配器
import { getPlatformAdapter } from '@huarongdao/platform';

const adapter = getPlatformAdapter();

// 使用存储
await adapter.storage.set('game_state', state);

// 使用设备信息
const screen = adapter.device.getScreenWidth();

// 使用提示
adapter.toast.show('操作成功');
```

## 📝 下一步计划

### 阶段一：核心层完善 ✅

- [x] 数据模型定义
- [x] 游戏逻辑实现
- [x] 平台接口定义
- [x] HarmonyOS适配器
- [x] Web适配器

### 阶段二：Web UI实现 🔄

- [ ] 创建React项目
- [ ] 实现棋盘组件
- [ ] 实现响应式布局
- [ ] 集成核心层

### 阶段三：移动端UI 📅

- [ ] React Native实现
- [ ] 或使用ArkUI-X
- [ ] 原生性能优化

### 阶段四：小程序 📅

- [ ] Taro/uni-app实现
- [ ] 微信小程序适配
- [ ] 性能优化

## 🎉 验收标准

- [x] 核心逻辑平台无关
- [x] HarmonyOS版本正常运行
- [ ] Web版本正常运行
- [ ] 游戏逻辑一致
- [ ] 无平台API直接调用
- [ ] 构建流程完整

## 📞 技术支持

如有问题，请查看：
- [核心层文档](../core/README.md)
- [平台适配文档](../platform/README.md)
- [架构设计文档](../docs/ARCHITECTURE.md)