//
//  MKReminderTarget.swift
//  WKM
//
//  Created by spring on 2022/7/5.
//  Copyright © 2022 Mico. All rights reserved.
//

import Foundation
import Combine

open class MKReminderTarget {
    /// 被观察对象的唯一识别符
    public var key: MKReminderKey
    
    public required init(_ key: MKReminderKey) {
        self.key = key
    }
    
    /// 当object成功绑定了观察对象
    /// - Parameter model: 被观察的对象
    open func onBind(model: MKReminderModel) {}
    
    /// 当被观察对象发生变化
    /// - Parameter value: 被观察对象变化后的值
    open func onValueChange(value: Int) {}
}

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
