//
//  ContentView.swift
//  MKReminder
//
//  Created by spring on 2023/12/18.
//

import SwiftUI
import Combine
import MKReminder

struct ContentView: View {
    
    @State var remindsMessage: Int = 0
    @State var remindsSystem: Int = 0
    @State var remindsTotal: Int = 0
    @State var newFriends: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            control
            Spacer()
            swiftuiBindView
            Spacer()
            uikitBindView
            Spacer()
        }
        .padding()
    }
    
    var control: some View {
        VStack {
            Text("Control")
                .font(.title)
            Button("message +1") {
                MKReminderManager.shared.increment(.message)
            }
            Button("message -1") {
                MKReminderManager.shared.decrement(.message)
            }
            Button("system +1") {
                MKReminderManager.shared.increment(.system)
            }
            Button("system -1") {
                MKReminderManager.shared.decrement(.system)
            }
            Button("new friends +1") {
                MKReminderManager.shared.increment(.newFriends)
            }
            Button("new friends -1") {
                MKReminderManager.shared.decrement(.newFriends)
            }
        }
        .frame(width: 300)
        .background(Color.yellow)
    }
    
    var swiftuiBindView: some View {
        VStack {
            Text("SwiftUI")
                .font(.title)
            Text("message: \(remindsMessage)")
                .bindReminder(targets: [CustomMKReminderTarget(.message)]) { key, count in
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
            Text("new friends(cache): \(newFriends)")
                .bindReminder(targets: [MKReminderUserDefaultsTarget(.newFriends)]) { key, count in
                    self.newFriends = count
                }
        }
        .frame(width: 300)
        .background(Color.orange)
    }
    
    var uikitBindView: some View {
        VStack {
            Text("UIKit")
                .font(.title)
            UIKitViewWrapper()
                .fixedSize()
        }
        .frame(width: 300)
        .background(Color.blue)
    }

}

extension MKReminderKey {
    static let message = "message"
    static let system = "system"
    static let newFriends = "newFriends"
}

#Preview {
    ContentView()
}

public class CustomMKReminderTarget: MKReminderTarget {
    public override func onBind(model: MKReminderModel) {
        print("custom reminder on bind: \(model)")
    }
    
    public override func onValueChange(value: Int) {
        print("custom reminder on count change: \(value)")
    }
}
