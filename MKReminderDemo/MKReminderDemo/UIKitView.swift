//
//  UIKitView.swift
//  MKReminder
//
//  Created by spring on 2023/12/18.
//

import UIKit
import SwiftUI
import SnapKit
import MKReminder

class UIKitView: UIView {
    
    lazy var btn = UIButton()
    weak var bindView: BindView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        btn.setTitle("add view", for: .normal)
        btn.addTarget(self, action: #selector(addBindView), for: .touchUpInside)
        addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        addBindView()
    }
    
    @objc func addBindView() {
        guard bindView == nil else { return }
        let bindView = BindView(frame: .zero)
        addSubview(bindView)
        bindView.snp.makeConstraints { make in
            make.top.equalTo(btn.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        self.bindView = bindView
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

class BindView: UIView {
    lazy var stackView = UIStackView(frame: .zero)
    lazy var labelMessage = UILabel(frame: .zero)
    lazy var labelSystem = UILabel(frame: .zero)
    lazy var labelFriend = UILabel(frame: .zero)
    lazy var labelCount = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(labelMessage)
        stackView.addArrangedSubview(labelSystem)
        stackView.addArrangedSubview(labelCount)
        
        labelMessage.bindReminder(targets: [.init(.message)]) { [weak self] _, count in
            self?.labelMessage.text = "message: \(count)"
        }
        
        labelSystem.bindReminder(targets: [.init(.system)]) { [weak self] _, count in
            self?.labelSystem.text = "system: \(count)"
        }
        
        labelCount.bindReminder(targets: [.init(.message), .init(.system)]) { [weak self] _, count in
            self?.labelCount.text = "message + system: \(count)"
        }
        
        labelCount.bindReminder(targets: [MKReminderUserDefaultsTarget(.newFriends)]) { [weak self] _, count in
            self?.labelCount.text = "new friends: \(count)"
        }
        
        let btn = UIButton()
        btn.setTitle("remove self", for: .normal)
        btn.addTarget(self, action: #selector(onClickBtn), for: .touchUpInside)
        stackView.addArrangedSubview(btn)
    }
    
    @objc func onClickBtn() {
        removeFromSuperview()
    }

}

struct UIKitViewWrapper: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<UIKitViewWrapper>) -> UIKitView {
        return UIKitView()
    }
    
    func updateUIView(_ uiView: UIKitView, context: UIViewRepresentableContext<UIKitViewWrapper>) {
    }
}
