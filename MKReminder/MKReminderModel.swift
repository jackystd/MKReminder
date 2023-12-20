//
//  MKReminderModel.swift
//  MKReminder
//
//  Created by spring on 2022/5/26.
//

import Foundation
import Combine

public class MKReminderModel: ObservableObject {
    /// 唯一识别符
    let key: MKReminderKey!
    private lazy var lock = NSLock()
    /// 红点提醒数量
    @Published private(set) var count: Int = 0
    
    required init(_ key: MKReminderKey) {
        self.key = key
    }
    
    public func update(count: Int) {
        lock.lock()
        defer { lock.unlock() }
        self.count = count
    }
}

extension MKReminderModel: CustomStringConvertible {
    public var description: String {
        return "ID:\(key ?? "") (\(count))"
    }
}
