# SwiftUI macOS Xcode Preview 布局 Demo

## 简介

这个 Demo 做了一个很典型的桌面布局：

- 顶部 toolbar
- 左侧 sidebar
- 中间主画布
- 中间次栏
- 右侧 inspector
- 底部 console panel

重点不是业务功能，而是演示一件事：

**怎样把 SwiftUI 页面写成“Xcode 不启动 app 也能直接预览布局”的形态。**

## 快速开始

### 环境要求

- macOS 14+
- Xcode 15+
- XcodeGen

安装 `XcodeGen`：

```bash
brew install xcodegen
```

### 运行

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-xcode-preview-layout-demo
./scripts/build.sh
open build/DerivedData/Build/Products/Debug/SwiftUIXcodePreviewLayoutDemo.app
```

如果你想直接打开工程：

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-xcode-preview-layout-demo
xcodegen generate
open SwiftUIXcodePreviewLayoutDemo.xcodeproj
```

## 重点：不启动程序，直接预览布局

### 操作步骤

1. 运行 `xcodegen generate`
2. 用 Xcode 打开 `SwiftUIXcodePreviewLayoutDemo.xcodeproj`
3. 打开 `Sources/LayoutPreviewShowcaseView.swift`
4. 菜单点 `Editor > Canvas`
5. 右侧 Canvas 出来后，点 `Resume`
6. 看 `Desktop Wide` 和 `Desktop Compact` 两个 `#Preview`

你不需要点 `Run`，也不需要真的启动 app。

### 为什么这个 Demo 可以直接 Preview

关键在这 3 点：

1. 预览对象是一个**纯 `View`**
2. 数据来自 `LayoutPreviewModel.sample`
3. 布局 view 里没有副作用

这里的“副作用”包括：

- 读网络
- 读数据库
- 申请系统权限
- 依赖 `AppDelegate`
- 依赖窗口句柄
- 启动 timer / task 去拉真实数据

本 Demo 把这些都避开了。

所以 `#Preview` 只需要构造一份假数据：

```swift
#Preview("Desktop Wide") {
    LayoutPreviewShowcaseView(model: .sample)
        .frame(width: 1280, height: 820)
}
```

Xcode Canvas 就能直接渲染。

## 教程

### 1. 正确拆法

推荐拆成两层：

第一层：`App`

- 只负责创建窗口
- 把根 view 放进去

第二层：纯布局 `View`

- 只吃结构化数据
- 只负责排版
- 不碰系统边界

本 Demo 就是：

- `SwiftUIXcodePreviewLayoutDemoApp.swift`
- `LayoutPreviewShowcaseView.swift`

### 2. 为什么很多 SwiftUI 页面不能稳定 Preview

常见原因不是“Xcode Preview 不行”，而是 view 写得太外层了。

比如把下面这些直接塞进页面：

- 权限请求
- `NSWindow` 操作
- 文件 IO
- `Task` 里拉真实接口
- 依赖复杂全局单例

这样 Preview 在 Canvas 里没有完整运行环境，就容易挂。

### 3. 这个 Demo 的布局结构

整体结构是：

```text
VStack
  topBar
  HStack
    leftSidebar
    centerRegion
      summary cards
      HStack
        canvasArea
        miniRightColumn
    rightInspector
  bottomPanel
```

也就是你说的那种：

- 左
- 上
- 下
- 右
- 中间再套一层左右

### 4. 什么时候该用 Preview，什么时候该 Run

适合 Preview：

- 看 padding
- 看 alignment
- 看 split 比例
- 看窄宽两种尺寸
- 看不同假数据下是否挤压

必须 Run：

- 看窗口行为
- 看快捷键
- 看权限弹窗
- 看文件拖拽
- 看菜单栏/多窗口
- 看 `NSWindow` / `NSViewRepresentable` 真实生命周期

## 注意事项

- Preview 更适合“纯布局 view”，不适合重副作用页面
- 若 Canvas 没反应，先确认打开的是 `LayoutPreviewShowcaseView.swift`
- 若 `#Preview` 不显示，确认 Xcode 版本至少 15
- 若页面逻辑越来越重，继续把“布局 view”和“副作用层”拆开，不要重新耦回去

## 源码入口

- `Sources/SwiftUIXcodePreviewLayoutDemoApp.swift`
- `Sources/LayoutPreviewShowcaseView.swift`
