//
//  MKReminderObserver.swift
//  MKReminder
//
//  Created by spring on 2022/5/26.
//

import UIKit
import SwiftUI
import Combine

public typealias MKReminderObserverCallback = ((MKReminderKey, Int) -> Void)

/// 由于闭包无法用weak修饰，此处生成一个对象来包装一个回调的闭包
class MKReminderVirtualObserver {
    /// 用来取消监听
    let cancellables: [AnyCancellable]
    /// 被观察对象发生变化时的回调block
    let callback: MKReminderObserverCallback
    
    init(cancellables: [AnyCancellable], callback: @escaping MKReminderObserverCallback) {
        self.cancellables = cancellables
        self.callback = callback
    }
}

fileprivate var k_virtual_observer = "k_virtual_observer"

extension UIView {
    
    private var __virtualObserver: MKReminderVirtualObserver? {
        get {
            objc_getAssociatedObject(self, &k_virtual_observer) as? MKReminderVirtualObserver
        }
        set {
            objc_setAssociatedObject(self, &k_virtual_observer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func bindReminder(targets: [MKReminderTarget], valueChange: @escaping MKReminderObserverCallback) {
        var cancellables: [AnyCancellable] = []
        for target in targets {
            let key = target.key
            let model = MKReminderManager.shared.obtainModel(key: key)
            target.onBind(model: model)
            let cancellable = model.$count
                .receive(on: RunLoop.main)
                .sink { v in
                    let total = MKReminderManager.shared.getTotal(keys: targets.compactMap({ $0.key }))
                    valueChange(key, total)
                    target.onValueChange(value: v)
                }
            cancellables.append(cancellable)
        }
        __virtualObserver = MKReminderVirtualObserver(cancellables: cancellables, callback: valueChange)
    }
    
    public func unbindReminder() {
        __virtualObserver?.cancellables.forEach {
            $0.cancel()
        }
    }
    
}

extension View {
    
    public func bindReminder(targets: [MKReminderTarget], perform: @escaping MKReminderObserverCallback) -> some View {
        var publishers: [Publishers.Map<Published<Int>.Publisher, (Published<Int>.Publisher.Output, MKReminderKey)>] = []
        for target in targets {
            let key = target.key
            let model = MKReminderManager.shared.obtainModel(key: key)
            target.onBind(model: model)
            let publisher = model.$count.map { ($0, target.key) }
            publishers.append(publisher)
        }

        let mergedPublisher = Publishers.MergeMany(publishers).receive(on: RunLoop.main)
        return self.onReceive(mergedPublisher, perform: { count, key in
            for target in targets {
                if target.key == key {
                    target.onValueChange(value: count)
                }
            }
            let total = MKReminderManager.shared.getTotal(keys: targets.compactMap({ $0.key }))
            perform(key, total)
        })
    }
    
}
