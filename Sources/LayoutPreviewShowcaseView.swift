import SwiftUI // 导入 SwiftUI。

struct LayoutPreviewShowcaseView: View { // 定义可直接被 Xcode Canvas 预览的纯布局 view。
    let model: LayoutPreviewModel // 注入整个页面需要的结构化数据。

    var body: some View { // 定义页面主体布局。
        VStack(spacing: 0) { // 最外层先做上下结构。
            topBar // 顶部工具条。
            Divider() // 顶部和主体间的分割线。
            HStack(spacing: 0) { // 中间区域再做左右结构。
                leftSidebar // 左侧导航栏。
                Divider() // 左栏和中间主区的分割线。
                centerRegion // 中间主区。
                Divider() // 中间主区和右栏的分割线。
                rightInspector // 右侧信息栏。
            } // 结束中间左右结构。
            Divider() // 主体和底部面板的分割线。
            bottomPanel // 底部输出面板。
        } // 结束最外层布局。
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 占满可用空间。
        .background(Color(nsColor: .windowBackgroundColor)) // 使用系统窗口背景色。
    } // 结束主体布局。

    private var topBar: some View { // 定义顶部工具条。
        HStack(spacing: 12) { // 水平排布顶部控件。
            Label("Layout Preview", systemImage: "rectangle.split.3x3") // 显示页面标题。
                .font(.title3.weight(.semibold)) // 强调标题。
            Spacer() // 把状态块推到右边。
            StatusPill(text: "Canvas Ready", color: .green) // 提示当前适合预览。
            StatusPill(text: "Pure View", color: .blue) // 提示当前 view 无副作用。
            Button("Run App") { } // 放一个占位按钮，对比“预览”和“真运行”。
                .buttonStyle(.bordered) // 使用系统边框样式。
        } // 结束顶部工具条内容。
        .padding(.horizontal, 18) // 增加左右内边距。
        .padding(.vertical, 14) // 增加上下内边距。
        .background(Color(nsColor: .controlBackgroundColor)) // 给顶部工具条单独背景。
    } // 结束顶部工具条。

    private var leftSidebar: some View { // 定义左侧导航栏。
        VStack(alignment: .leading, spacing: 14) { // 垂直排布左栏内容。
            Text("左栏") // 标题。
                .font(.headline) // 用标题样式。
            ForEach(model.sidebarItems) { item in // 遍历左栏条目。
                HStack(spacing: 10) { // 条目内部水平排布。
                    Image(systemName: item.icon) // 显示条目标识图标。
                        .frame(width: 18) // 固定图标宽度。
                    Text(item.title) // 显示条目标题。
                    Spacer() // 把数量推到右边。
                    Text(item.badge) // 显示条目徽标。
                        .font(.footnote.monospacedDigit()) // 用等宽数字。
                        .foregroundStyle(.secondary) // 弱化徽标颜色。
                } // 结束条目内容。
                .padding(.horizontal, 12) // 加左右内边距。
                .padding(.vertical, 10) // 加上下内边距。
                .frame(maxWidth: .infinity, alignment: .leading) // 宽度拉满并左对齐。
                .background(item.isSelected ? Color.accentColor.opacity(0.14) : Color.clear) // 给选中项浅底色。
                .clipShape(RoundedRectangle(cornerRadius: 10)) // 做圆角。
            } // 结束左栏遍历。
            Spacer() // 把底部说明推到最下面。
            VStack(alignment: .leading, spacing: 6) { // 放一段用途说明。
                Text("预览要点") // 标题。
                    .font(.subheadline.weight(.semibold)) // 强调说明标题。
                Text("左栏只是静态假数据。Preview 时别连 DB、别申请权限、别依赖 AppDelegate。") // 点明 preview 纯 view 原则。
                    .font(.footnote) // 用小字。
                    .foregroundStyle(.secondary) // 弱化说明文字。
            } // 结束说明区。
        } // 结束左栏布局。
        .padding(16) // 增加边距。
        .frame(width: 220) // 固定左栏宽度。
        .frame(maxHeight: .infinity, alignment: .topLeading) // 让左栏撑满高度。
        .background(Color(nsColor: .underPageBackgroundColor)) // 设置左栏背景。
    } // 结束左侧导航栏。

    private var centerRegion: some View { // 定义中间主区。
        VStack(spacing: 0) { // 主区先分上中下。
            HStack(spacing: 12) { // 主区顶部 summary 卡片行。
                ForEach(model.summaryCards) { card in // 遍历摘要卡片。
                    SummaryCardView(card: card) // 渲染摘要卡片。
                } // 结束摘要卡片遍历。
            } // 结束摘要卡片行。
            .padding(18) // 给顶部 summary 留边距。
            Divider() // 摘要区与编辑区间的分割线。
            HStack(spacing: 0) { // 编辑区再做左右分栏。
                canvasArea // 左上主画布区。
                Divider() // 画布和次栏间的分割线。
                miniRightColumn // 中间主区里的右侧次栏。
            } // 结束编辑区左右结构。
        } // 结束主区布局。
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 主区占满剩余空间。
    } // 结束中间主区。

    private var canvasArea: some View { // 定义左上主画布区。
        VStack(alignment: .leading, spacing: 14) { // 垂直排布主画布内容。
            HStack { // 放画布标题与缩放信息。
                Text("左上主画布") // 标题。
                    .font(.title3.weight(.semibold)) // 强调标题。
                Spacer() // 把缩放信息推到右边。
                Text("1440 × 900  Mock") // 显示假尺寸。
                    .font(.footnote.monospaced()) // 用等宽字体显示尺寸。
                    .foregroundStyle(.secondary) // 弱化尺寸。
            } // 结束画布标题行。
            ZStack { // 创建主画布容器。
                RoundedRectangle(cornerRadius: 18) // 先铺一个圆角底板。
                    .fill(Color.accentColor.opacity(0.08)) // 设置主画布背景。
                VStack(alignment: .leading, spacing: 12) { // 画布内容垂直排布。
                    HStack(spacing: 10) { // 第一行放模块标签。
                        CanvasChip(text: "Hero") // 标签 1。
                        CanvasChip(text: "Toolbar") // 标签 2。
                        CanvasChip(text: "Inspector Hook") // 标签 3。
                    } // 结束标签行。
                    Spacer() // 推开上下区域。
                    HStack(alignment: .bottom, spacing: 14) { // 底部放两块可视区。
                        CanvasBlock(title: "Chart", subtitle: "左大区") // 左大块。
                        VStack(spacing: 14) { // 右侧再上下分两块。
                            CanvasBlock(title: "Tasks", subtitle: "右上") // 右上块。
                            CanvasBlock(title: "Events", subtitle: "右下") // 右下块。
                        } // 结束右侧两块。
                        .frame(width: 220) // 固定右侧堆叠宽度。
                    } // 结束底部内容区。
                } // 结束画布内容。
                .padding(18) // 给画布内容加内边距。
            } // 结束主画布容器。
            .overlay( // 叠加边框。
                RoundedRectangle(cornerRadius: 18) // 创建同尺寸描边。
                    .stroke(Color.accentColor.opacity(0.28), lineWidth: 1) // 绘制浅描边。
            ) // 结束描边。
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 画布占满左上区域。
            Text("这块故意做成纯静态布局，方便在 Preview 中只验证 spacing、对齐、分栏比例。") // 说明当前区域目的。
                .font(.footnote) // 用脚注字体。
                .foregroundStyle(.secondary) // 弱化说明。
        } // 结束主画布区布局。
        .padding(18) // 给主画布区整体留边距。
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // 拉满空间并从左上开始布局。
    } // 结束左上主画布区。

    private var miniRightColumn: some View { // 定义中间主区里的右侧次栏。
        VStack(alignment: .leading, spacing: 14) { // 垂直排布次栏内容。
            Text("中间次栏") // 标题。
                .font(.headline) // 使用标题样式。
            ForEach(model.todoItems) { item in // 遍历待办。
                VStack(alignment: .leading, spacing: 6) { // 每个待办块内部垂直排布。
                    Text(item.title) // 显示待办标题。
                        .font(.subheadline.weight(.semibold)) // 强调标题。
                    Text(item.detail) // 显示待办细节。
                        .font(.footnote) // 用小字。
                        .foregroundStyle(.secondary) // 弱化细节文字。
                } // 结束待办块。
                .padding(12) // 加边距。
                .frame(maxWidth: .infinity, alignment: .leading) // 宽度拉满并左对齐。
                .background(Color.orange.opacity(0.10)) // 设置浅橙背景。
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 做圆角。
            } // 结束待办遍历。
            Spacer() // 把底部说明推下去。
        } // 结束次栏布局。
        .padding(16) // 给次栏边距。
        .frame(width: 240) // 固定次栏宽度。
        .frame(maxHeight: .infinity, alignment: .topLeading) // 让次栏撑满高度。
        .background(Color(nsColor: .controlBackgroundColor)) // 设置次栏背景。
    } // 结束中间次栏。

    private var rightInspector: some View { // 定义右侧信息栏。
        VStack(alignment: .leading, spacing: 16) { // 垂直排布右栏内容。
            Text("右栏 Inspector") // 标题。
                .font(.headline) // 用标题样式。
            InspectorSection(title: "Spacing") { // 第一组检查项。
                InspectorMetricRow(name: "Sidebar", value: "220") // 行 1。
                InspectorMetricRow(name: "Inspector", value: "260") // 行 2。
                InspectorMetricRow(name: "Bottom", value: "180") // 行 3。
            } // 结束 spacing 检查。
            InspectorSection(title: "Preview Tips") { // 第二组提示。
                Text("1. 打开 `LayoutPreviewShowcaseView.swift`") // 提示 1。
                Text("2. `Editor > Canvas`") // 提示 2。
                Text("3. 点 `Resume`") // 提示 3。
                Text("4. 看多个 `#Preview` 尺寸") // 提示 4。
            } // 结束 preview 提示。
            InspectorSection(title: "Why It Works") { // 第三组解释。
                Text("布局 view 不读系统状态。") // 解释 1。
                Text("数据走 `LayoutPreviewModel.sample`。") // 解释 2。
                Text("没有 timer / network / permission。") // 解释 3。
            } // 结束原理解释。
            Spacer() // 把底部空白推开。
        } // 结束右栏布局。
        .padding(16) // 给右栏边距。
        .frame(width: 260) // 固定右栏宽度。
        .frame(maxHeight: .infinity, alignment: .topLeading) // 让右栏撑满高度。
        .background(Color(nsColor: .underPageBackgroundColor)) // 设置右栏背景。
    } // 结束右侧信息栏。

    private var bottomPanel: some View { // 定义底部面板。
        VStack(alignment: .leading, spacing: 10) { // 垂直排布底部内容。
            HStack { // 底部标题行。
                Text("底部面板") // 标题。
                    .font(.headline) // 用标题样式。
                Spacer() // 把状态推右边。
                Text("Preview-only mock logs") // 显示状态。
                    .font(.footnote.monospaced()) // 用等宽字体。
                    .foregroundStyle(.secondary) // 弱化状态色。
            } // 结束底部标题行。
            ForEach(model.logLines, id: \.self) { line in // 遍历日志行。
                Text(line) // 显示日志。
                    .font(.system(.body, design: .monospaced)) // 用等宽字体模拟控制台。
                    .foregroundStyle(.secondary) // 弱化日志颜色。
            } // 结束日志遍历。
        } // 结束底部面板布局。
        .padding(.horizontal, 18) // 给底部左右边距。
        .padding(.vertical, 14) // 给底部上下边距。
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading) // 固定底部高度。
        .background(Color(nsColor: .controlBackgroundColor)) // 设置底部背景。
    } // 结束底部面板。
} // 结束主布局 view。

struct LayoutPreviewModel { // 定义页面需要的纯数据模型。
    let sidebarItems: [SidebarItem] // 左栏条目。
    let summaryCards: [SummaryCard] // 顶部摘要卡片。
    let todoItems: [TodoItem] // 中间次栏条目。
    let logLines: [String] // 底部日志文本。

    static let sample = LayoutPreviewModel( // 提供给 app 和 preview 共用的假数据。
        sidebarItems: [ // 构造左栏数据。
            SidebarItem(title: "Overview", icon: "square.grid.2x2", badge: "12", isSelected: true), // 条目 1。
            SidebarItem(title: "Orders", icon: "cart", badge: "08", isSelected: false), // 条目 2。
            SidebarItem(title: "Customers", icon: "person.3", badge: "21", isSelected: false), // 条目 3。
            SidebarItem(title: "Reports", icon: "chart.bar", badge: "05", isSelected: false), // 条目 4。
        ], // 结束左栏数据。
        summaryCards: [ // 构造摘要卡片数据。
            SummaryCard(title: "Revenue", value: "$128k", accent: .blue), // 卡片 1。
            SummaryCard(title: "Active Users", value: "2,304", accent: .green), // 卡片 2。
            SummaryCard(title: "Alerts", value: "07", accent: .orange), // 卡片 3。
        ], // 结束摘要卡片数据。
        todoItems: [ // 构造次栏待办数据。
            TodoItem(title: "Align top spacing", detail: "验证 summary 与画布的上边距是否一致。"), // 待办 1。
            TodoItem(title: "Test compact width", detail: "看 900 宽时右栏是否还能读。"), // 待办 2。
            TodoItem(title: "Check divider rhythm", detail: "确认上下左右分栏线没有太挤。"), // 待办 3。
        ], // 结束待办数据。
        logLines: [ // 构造底部日志。
            "[preview] using static sample data", // 日志 1。
            "[preview] canvas validates spacing, not business logic", // 日志 2。
            "[preview] no app launch required", // 日志 3。
        ] // 结束日志数据。
    ) // 结束 sample。
} // 结束布局模型定义。

struct SidebarItem: Identifiable { // 定义左栏条目模型。
    let id = UUID() // 自动生成标识。
    let title: String // 条目标题。
    let icon: String // 系统图标名。
    let badge: String // 右侧徽标。
    let isSelected: Bool // 是否选中。
} // 结束左栏条目模型。

struct SummaryCard: Identifiable { // 定义摘要卡片模型。
    let id = UUID() // 自动生成标识。
    let title: String // 卡片标题。
    let value: String // 卡片值。
    let accent: Color // 卡片主色。
} // 结束摘要卡片模型。

struct TodoItem: Identifiable { // 定义待办模型。
    let id = UUID() // 自动生成标识。
    let title: String // 待办标题。
    let detail: String // 待办说明。
} // 结束待办模型。

private struct StatusPill: View { // 定义顶部状态标签。
    let text: String // 标签文字。
    let color: Color // 标签颜色。

    var body: some View { // 定义标签样式。
        Text(text) // 显示标签文字。
            .font(.system(size: 12, weight: .medium, design: .rounded)) // 使用圆角字体。
            .padding(.horizontal, 10) // 设置水平内边距。
            .padding(.vertical, 6) // 设置垂直内边距。
            .background(color.opacity(0.14)) // 设置浅色背景。
            .clipShape(Capsule()) // 做成胶囊。
    } // 结束标签样式。
} // 结束顶部状态标签。

private struct SummaryCardView: View { // 定义摘要卡片 view。
    let card: SummaryCard // 注入卡片数据。

    var body: some View { // 定义卡片样式。
        VStack(alignment: .leading, spacing: 10) { // 垂直排布卡片内容。
            Text(card.title) // 显示标题。
                .font(.subheadline.weight(.medium)) // 设置标题字体。
                .foregroundStyle(.secondary) // 弱化标题色。
            Text(card.value) // 显示值。
                .font(.system(size: 28, weight: .bold, design: .rounded)) // 放大值。
            Spacer(minLength: 0) // 把底部标签推下去。
            StatusPill(text: "Mock", color: card.accent) // 显示 mock 标签。
        } // 结束卡片内容。
        .padding(16) // 设置卡片内边距。
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading) // 统一卡片尺寸。
        .background(card.accent.opacity(0.10)) // 设置卡片背景。
        .clipShape(RoundedRectangle(cornerRadius: 16)) // 做圆角。
        .overlay( // 叠加描边。
            RoundedRectangle(cornerRadius: 16) // 创建同尺寸图形。
                .stroke(card.accent.opacity(0.22), lineWidth: 1) // 绘制浅描边。
        ) // 结束描边。
    } // 结束卡片样式。
} // 结束摘要卡片 view。

private struct CanvasChip: View { // 定义画布小标签。
    let text: String // 标签文字。

    var body: some View { // 定义标签样式。
        Text(text) // 显示标签文字。
            .font(.footnote.weight(.semibold)) // 设置标签字体。
            .padding(.horizontal, 10) // 设置水平内边距。
            .padding(.vertical, 6) // 设置垂直内边距。
            .background(Color.white.opacity(0.75)) // 设置浅白背景。
            .clipShape(Capsule()) // 做成胶囊。
    } // 结束标签样式。
} // 结束画布小标签。

private struct CanvasBlock: View { // 定义画布里的矩形块。
    let title: String // 块标题。
    let subtitle: String // 块副标题。

    var body: some View { // 定义矩形块样式。
        VStack(alignment: .leading, spacing: 8) { // 垂直排布块内容。
            Text(title) // 显示标题。
                .font(.headline) // 强调标题。
            Text(subtitle) // 显示副标题。
                .font(.footnote) // 用小字。
                .foregroundStyle(.secondary) // 弱化副标题。
            Spacer(minLength: 0) // 让块内容贴上方。
        } // 结束块内容布局。
        .padding(14) // 设置内边距。
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // 拉满可用空间。
        .background(Color.white.opacity(0.72)) // 设置块背景。
        .clipShape(RoundedRectangle(cornerRadius: 14)) // 做圆角。
    } // 结束矩形块样式。
} // 结束画布矩形块。

private struct InspectorSection<Content: View>: View { // 定义右栏分组容器。
    let title: String // 分组标题。
    @ViewBuilder let content: Content // 分组内容。

    var body: some View { // 定义分组样式。
        VStack(alignment: .leading, spacing: 10) { // 垂直排布分组内容。
            Text(title) // 显示分组标题。
                .font(.subheadline.weight(.semibold)) // 强调标题。
            content // 注入调用方内容。
        } // 结束分组布局。
        .padding(14) // 增加边距。
        .frame(maxWidth: .infinity, alignment: .leading) // 宽度拉满。
        .background(Color(nsColor: .controlBackgroundColor)) // 设置分组背景。
        .clipShape(RoundedRectangle(cornerRadius: 12)) // 做圆角。
    } // 结束分组样式。
} // 结束右栏分组容器。

private struct InspectorMetricRow: View { // 定义右栏键值行。
    let name: String // 名称。
    let value: String // 值。

    var body: some View { // 定义键值行样式。
        HStack { // 水平排布键和值。
            Text(name) // 显示名称。
            Spacer() // 把值推到右边。
            Text(value) // 显示值。
                .font(.system(.body, design: .monospaced)) // 用等宽字体。
                .foregroundStyle(.secondary) // 弱化值颜色。
        } // 结束键值行布局。
    } // 结束键值行样式。
} // 结束右栏键值行。

#Preview("Desktop Wide") { // 定义宽屏预览。
    LayoutPreviewShowcaseView(model: .sample) // 直接预览纯布局 view。
        .frame(width: 1280, height: 820) // 设定宽屏尺寸。
} // 结束宽屏预览。

#Preview("Desktop Compact") { // 定义紧凑预览。
    LayoutPreviewShowcaseView(model: .sample) // 继续使用同一份假数据。
        .frame(width: 960, height: 720) // 设定紧凑尺寸。
} // 结束紧凑预览。
