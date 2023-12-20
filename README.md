# MKReminder

一个轻量的红点提醒组件
* 通过组合监听目标，以响应式的形式为多层级红点提醒联动的场景提供解决方案；
* 开发者不需要关系闭包的释放问题，当视图被移除，其绑定关系会自动解除；
* 响应链基于combine，兼容SwiftUI和UIKit；

## 在SwiftUI中使用
``` swift
struct TestView: View {
    
    @State var remindsMessage: Int = 0
    @State var remindsSystem: Int = 0
    @State var remindsTotal: Int = 0
    
    var body: some View {
        VStack {
            // 监听
            Text("message: \(remindsMessage)")
                .bindReminder(targets: [init(.message)]) { key, count in
                    self.remindsMessage = count
                }
            Text("system: \(remindsSystem)")
                .bindReminder(targets: [.init(.system)]) { key, count in
                    self.remindsSystem = count
                }
            Text("message + system: \(remindsTotal)")
                .bindReminder(targets: [.init(.message), .init(.system)]) { key, count in
                    self.remindsTotal = count
                }
            Button("message +1") {
                // 模拟改变数量
                MKReminderManager.shared.increment(.message)
            }
        }
    }
}

extension MKReminderKey {
    static let message = "message"
    static let system = "system"
}
```

## 在UIKit中使用
```swift
labelMessage.bindReminder(targets: [.init(.message)]) { [weak self] _, count in
    self?.labelMessage.text = "message: \(count)"
}
labelCount.bindReminder(targets: [.init(.message), .init(.system)]) { [weak self] _, count in
    self?.labelCount.text = "message + system: \(count)"
}
// 解除绑定
labelCount.unbindReminder()
```

## 自定义监听目标行为
继承MKReminderTarget，通过重写 onBind 和 onValueChange 函数，可以实现一些自定义逻辑，以帮助你快速构建。
```swift
// 这个target的count初始值从UserDefaults中读取，count发生变化时会写入UserDefaults
public class MKReminderUserDefaultsTarget: MKReminderTarget {
    public override func onBind(model: MKReminderModel) {
        let count = UserDefaults.standard.integer(forKey: key)
        model.update(count: count)
    }
    
    public override func onValueChange(value: Int) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
```