//
//  MKReminderManager.swift
//  MKReminder
//
//  Created by spring on 2022/5/26.
//

import UIKit

public class MKReminderManager {
    
    public static let shared = MKReminderManager()
    private lazy var lock = NSLock()
    private var models = [MKReminderKey: MKReminderModel]()

    @discardableResult
    /// 通过key获取一个被观察对象，如果不存在则创建
    /// - Parameter key: 被观察对象的唯一识别符
    /// - Returns: 被观察对象
    func obtainModel(key: MKReminderKey) -> MKReminderModel {
        lock.lock()
        defer { lock.unlock() }
        if let model = models[key] {
            return model
        }
        let model = MKReminderModel(key)
        models.updateValue(model, forKey: key)
        return model
    }
}

public extension MKReminderManager {
    func reset(_ key: MKReminderKey, to: Int = 0) {
        let fixed = max(0, to)
        obtainModel(key: key).update(count: fixed)
    }
    
    func increment(_ key: MKReminderKey, by: Int = 1) {
        reset(key, to: obtainModel(key: key).count.safeAdd(by))
    }
    
    func decrement(_ key: MKReminderKey, by: Int = 1) {
        reset(key, to: obtainModel(key: key).count.safeSub(by))
    }
    
    func getTotal(keys: [MKReminderKey]) -> Int {
        var total = 0
        keys.compactMap {
            MKReminderManager.shared.obtainModel(key: $0).count
        }.forEach {
            total = total.safeAdd($0)
        }
        return total
    }
}

extension Int {
    func safeAdd(_ other: Int) -> Int {
        return Int.max - other >= self ? self + other : Int.max
    }
    
    func safeSub(_ other: Int) -> Int {
        self >= Int.min + other ? self - other : Int.min
    }
}

extension MKReminderManager {
    func modelsInfo() -> String {
        return models.compactMap { "\($0)" }.joined(separator: " | ")
    }
}
