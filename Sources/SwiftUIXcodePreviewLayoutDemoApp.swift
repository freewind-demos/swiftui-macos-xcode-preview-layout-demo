import SwiftUI // 导入 SwiftUI。

@main // 声明应用入口。
struct SwiftUIXcodePreviewLayoutDemoApp: App { // 定义 demo app。
    var body: some Scene { // 定义主场景。
        Window("Xcode Preview Layout Demo", id: "main") { // 创建主窗口。
            LayoutPreviewShowcaseView(model: .sample) // 把纯布局 view 放进窗口。
        } // 结束窗口内容。
        .defaultSize(width: 1280, height: 820) // 设定默认窗口尺寸。
    } // 结束场景定义。
} // 结束 app 定义。
